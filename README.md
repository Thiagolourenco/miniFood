# MiniFood (Fresko)

A food‑delivery iOS app built with **SwiftUI** as a personal project to practice my studies in modern Apple development: SwiftUI, the **Observation** framework, **async/await**, **MVVM**, **Keychain** and REST API integration.

> Xcode project: `MiniFood` • App display name: `Fresko`

## About

**MiniFood / Fresko** simulates a delivery app: the user signs in, browses restaurants, opens a product and (eventually) places an order. It is a **study project** — the goal is to use a realistic domain as an excuse to exercise navigation, state management, reusable components, networking and authentication.

## Tech stack

- **Swift 5** + **SwiftUI** (iOS 26.2 target)
- **`@Observable`** (Observation framework) for ViewModels and `SessionManager`
- **`async`/`await`** + **`withThrowingTaskGroup`** for parallel requests
- **MVVM** with a generic networking layer (`ApiClient` + `ApiRequest` + `APIRoute`)
- **Keychain** for token persistence (`KeychainService`)
- **Automatic refresh‑token** on `401`
- `NavigationStack` for navigation

## Architecture

The app follows **MVVM + Service layer**, organized by feature, on top of a generic networking layer.

```
View (SwiftUI)
    │  binds
    ▼
ViewModel (@Observable)
    │  calls
    ▼
Service (protocol)  ─────────────▶  ApiClient.execute(ApiRequest<T>)
                                        │
                                        │  attaches Bearer token from Keychain
                                        │  retries once on 401 via /auth/refresh
                                        ▼
                                  REST API (URLSession)
```

- **View**: dumb, binds to ViewModel state.
- **ViewModel**: `@Observable` class holding UI state (`isLoading`, `errorMessage`, results...) and orchestrating calls.
- **Service**: a `struct` conforming to a feature `protocol` (e.g. `HomeServiceProtocol`, `RestaurantProtocol`, `ProductServiceProtocol`), so it can be mocked in tests/previews (a `MockXxxService` lives next to each real one).
- **ApiClient**: a single generic client that takes an `ApiRequest<Response>` and returns a decoded `Response`. It injects the `Authorization` header from Keychain and transparently calls `/auth/refresh` when a request returns `401`.
- **APIRoute**: a typed enum that groups every endpoint (`.auth`, `.home`, `.restaurant`, `.product`), so services never deal with raw strings.
- **SessionManager**: an `@Observable` source of truth for `isAuthenticated`. `ManagerAuth` decides whether to show `Login` or `MainTabView` based on it.
- **Errors**: typed `enum AuthServiceError: LocalizedError` exposed to the UI via `error.localizedDescription`.

## Project structure

```
MiniFood/
├── MiniFoodApp.swift                  # @main, injects SessionManager
├── Components/
│   ├── Header.swift                   # Reusable header
│   └── ImageLoader.swift              # Async image loader (URLSession + @Observable)
├── Core/
│   ├── ManagerAuth.swift              # SessionManager + ManagerAuth (Login vs Tabs)
│   ├── TabView.swift                  # MainTabView (custom tab bar)
│   ├── Model/TabItemModel.swift
│   ├── Login/                         # Entry screen
│   ├── ContinueWithEmail/             # Email login / register
│   ├── Home/                          # MVVM with parallel fetch
│   ├── Restaurant/                    # MVVM with parallel fetch
│   ├── Product/                       # MVVM
│   └── Settings/                      # MVVM (logout)
├── Networking/
│   ├── Client/ApiClient.swift         # Generic execute + refresh-token retry
│   ├── Requests/ApiRequest.swift      # Generic ApiRequest<Response>
│   ├── Route/ApiRoute.swift           # APIRoute enum + URLConstants
│   ├── Endpoints/
│   │   ├── AuthEndpoint.swift
│   │   ├── HomeSection.swift          # categories / restaurants
│   │   ├── Restaurants.swift          # restaurants / restaurants/:id
│   │   └── ProductEndpoint.swift      # restaurants/:id/products, products/:id
│   └── Error/AuthServiceError.swift
├── Security/
│   └── KeychainService.swift          # Save/read/delete tokens
├── Helpers/
│   └── TabBarVisibilityHelper.swift   # tabBarVisibility (Environment)
└── Assets.xcassets/
```

## Networking layer

All requests go through a single generic client.

```swift
struct ApiRequest<Response: Decodable> {
    let method: HttpMethod        // .get / .post / .put / .delete
    let path: String
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: Data?
}

struct ApiClient {
    var baseURL: URL
    func execute<Response>(_ request: ApiRequest<Response>) async throws -> Response
}
```

Inside `ApiClient.execute`:

1. Reads `accessToken` from **Keychain** and adds `Authorization: Bearer <token>`.
2. Performs the request with `URLSession`.
3. On `401`, calls `refreshToken()` (POST `/auth/refresh`), stores the new tokens in Keychain and retries the original request **once**.
4. On non‑2xx, decodes `ApiResponseError` and throws `AuthServiceError.api(message:)`.
5. On success, decodes `Response` with `JSONDecoder` and returns it.

This means every service is just a thin wrapper around `ApiRequest` — no more duplicated `URLRequest` boilerplate.

### Endpoints

Base URL: `http://localhost:3000/v1/`

| Group        | Method | Path                                  | Used by                                 |
|--------------|--------|---------------------------------------|-----------------------------------------|
| **auth**     | POST   | `/auth/check-email`                   | `ContinueWithEmailService.validEmail`   |
|              | POST   | `/auth/register`                      | `ContinueWithEmailService.registerUser` |
|              | POST   | `/auth/login`                         | `ContinueWithEmailService.login`        |
|              | POST   | `/auth/refresh`                       | `ApiClient.refreshToken` (transparent)  |
| **home**     | GET    | `/categories`                         | `HomeService.getHomeData`               |
|              | GET    | `/restaurants`                        | `HomeService.getHomeData`               |
| **restaurant** | GET  | `/restaurants/:id`                    | `RestaurantService.getRestaurantDetails`|
| **product**  | GET    | `/restaurants/:id/products`           | `RestaurantService.getRestaurantDetails`|
|              | GET    | `/products/:id`                       | `ProductService.getProduct`             |

Full backend contract: [`docs/BACKEND_AUTH.md`](docs/BACKEND_AUTH.md).

## Concurrency: parallel requests

Both `HomeService` and `RestaurantService` use **`withThrowingTaskGroup`** to fan out independent requests in parallel and aggregate the results, instead of awaiting them sequentially.

```swift
// HomeService — fetches categories and restaurants in parallel
let sections = try await withThrowingTaskGroup(of: HomeSection.self) { group in
    for endpoint in [HomeSectionEndpoint.categories, .restaurants] {
        group.addTask { try await self.fetchSection(endpoint) }
    }
    var sections: [HomeSection] = []
    for try await section in group { sections.append(section) }
    return sections
}
```

`RestaurantService.getRestaurantDetails(id:)` does the same: loads the restaurant info and its products in parallel and returns a single `RestaurantDetailsData`.

## Auth & session

- **`KeychainService`** persists `accessToken` and `refreshToken` securely using `Security.framework` (`kSecClassGenericPassword`).
- **`SessionManager`** (`@Observable`) exposes `isAuthenticated`, checks Keychain on init and provides a `logout()` that wipes both tokens.
- **`ManagerAuth`** is the app root view: it observes `SessionManager` from the `Environment` and routes to either `Login` or `MainTabView`.
- **`ContinueWithEmailService`** saves the tokens to Keychain on `register` and `login`.
- **`SettingsViewModel.logout(sessionManager:)`** triggers a global logout from the Settings tab.

```swift
@main
struct MiniFoodApp: App {
    @State private var manageSession = SessionManager()
    var body: some Scene {
        WindowGroup {
            ManagerAuth().environment(manageSession)
        }
    }
}
```

## App flow

```
MiniFoodApp
└── ManagerAuth                              ← checks Keychain on launch
    │
    ├── isAuthenticated == false ──▶ Login
    │     ├── [Apple] / [Google]   (not wired yet)
    │     └── [Email] ──▶ ContinueWithEmail
    │                       │
    │                       │  debounce 700ms
    │                       │  POST /auth/check-email
    │                       ▼
    │                ┌──────────────────┐
    │                │  exists == true? │
    │                └──────────────────┘
    │                   │            │
    │                   ▼ yes        ▼ no
    │                Login form   Register form
    │                   │            │
    │           POST /auth/login   POST /auth/register
    │                   └─────┬──────┘
    │                         ▼
    │            save tokens → Keychain
    │            SessionManager.isAuthenticated = true
    │
    └── isAuthenticated == true ──▶ MainTabView
          ├── Home       (GET /categories + /restaurants, in parallel)
          ├── Orders / Privacy / Profile
          └── Settings   ──▶ logout() → wipe Keychain → back to Login

  Restaurant ──▶ Product
  (GET /restaurants/:id + /restaurants/:id/products, in parallel)
```

Key behaviors:

- The **email input is debounced (700ms)** before calling the API to avoid a request per keystroke.
- The response of `/auth/check-email` decides whether `ContinueWithEmail` shows the **Login** or **Register** form.
- On success, tokens are saved to Keychain and `SessionManager.isAuthenticated` flips to `true` — `ManagerAuth` swaps the root view.
- `ApiClient` transparently refreshes tokens on `401` and retries the request once before giving up.
- `Home` and `Restaurant` details are loaded with **parallel requests** via `withThrowingTaskGroup`.
- `ImageLoader` is an `@Observable` view that fetches remote images asynchronously with a loading state and a fallback icon.

## Getting started

Requirements: Xcode with iOS 26 SDK, simulator running iOS 26.2+.

```bash
git clone https://github.com/<your-user>/MiniFood.git
cd MiniFood
open MiniFood.xcodeproj
```

Start a backend on `http://localhost:3000` (see `docs/BACKEND_AUTH.md`) exposing the endpoints listed above, or change the base URL in `Networking/Route/ApiRoute.swift` (`URLConstants.fakeStoreAPI`), then press **⌘R**.

## Roadmap

- [x] Keychain for `accessToken` / `refreshToken`
- [x] `SessionManager` + route guard (Login vs MainTabView)
- [x] Generic `APIClient` + `ApiRequest` + `APIRoute`
- [x] Automatic refresh‑token on `401`
- [x] ViewModels for Home / Restaurant / Product
- [x] Logout from Settings
- [x] Async image loader (`ImageLoader`)
- [x] Mock services for previews/tests (`MockHomeService`, `MockRestaurantService`, `MockProductService`)
- [ ] Sign in with Apple & Google
- [ ] Unit tests for ViewModels with mock services
- [ ] Cart & checkout flow
- [ ] Move refresh‑token logic out of `ApiClient` into a dedicated `AuthInterceptor`

## Author

Made by **Thiago Lourenço** as a SwiftUI study project. Feedback on architecture and SwiftUI idioms is very welcome.
