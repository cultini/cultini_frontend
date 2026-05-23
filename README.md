# Cultini — Flutter frontend

Mobile frontend for **Cultini / Azetta**, a RAG-based anti-cultural-homogenization
project focused on Amazigh (Berber) craftsmanship in Algeria. This app talks to two
separate backends (auth + AI/RAG); all AI logic lives server-side.

## Stack

- **Flutter** + **Dart**
- **State management:** `flutter_bloc` (Bloc + Cubit)
- **Dependency injection:** `get_it` (`lib/di/injection_container.dart`)
- **Networking:** `http` wrapped in `ApiClient` (`lib/core/network/api_client.dart`)
- **Navigation:** `go_router` (top-level) + imperative `Navigator` for detail screens
- **Maps:** `flutter_map` + OpenStreetMap tiles (one tappable marker per wilaya)
- **Local storage:** `shared_preferences` / `flutter_secure_storage` via `AppLocalStorage`
- **Config:** `flutter_dotenv` (`.env`)

> Clean architecture per feature: `domain` (entities, repository interfaces, usecases) →
> `data` (models, datasources, repository impls) → `presentation` (bloc/cubit, screens, widgets).

## Project structure

```
lib/
├── core/                     # shared infrastructure
│   ├── constants/            # end_points.dart (base URLs + paths), app_strings, storage_keys
│   ├── network/              # api_client.dart, network_info.dart
│   ├── storage/              # app_local_storage.dart
│   ├── theme/                # single ThemeData + color/metric/text tokens
│   ├── router/               # go_router config + route names
│   ├── validators/           # AppValidators (email, password, …)
│   ├── widgets/              # AppTextField, PrimaryButton, …
│   └── data/dummy_data.dart  # mock corpus for Documentation (no backend yet)
├── di/injection_container.dart   # get_it registrations
├── navigation/main_navigation.dart  # bottom-nav shell (Map · Docs · Chat · Contribuer · Profil)
└── features/
    ├── auth/                 # login/register/splash → Node /api/auth, AuthBloc
    ├── chat/                 # AI chat → FastAPI /chat, sources + metrics
    ├── docs/                 # searchable/filterable documentation + detail (mock)
    ├── contribution/         # validated suggestion form (mock, stores locally)
    ├── map/                  # 58 tappable wilayas → Documentation pre-filtered
    └── profile/              # signed-in user + logout
```

## Repository pattern (mock ↔ real)

Every backend interaction goes through a **repository interface** in `domain/repositories/`,
implemented in `data/repositories/`. Implementations delegate to **datasources**
(`*_remote_data_source.dart` for HTTP, `*_local_data_source.dart` for cache/mock). Swapping
mock for real means changing a datasource/binding — no widget touches HTTP directly.

| Feature | Today | Backend |
|---|---|---|
| Auth | **Live HTTP** | Node/Express `POST /api/auth/{login,register}` |
| Chat | **Live HTTP** | FastAPI `POST /chat` `{chat_id, question}` → `{response, source_nodes[], metrics}` |
| Documentation | **Mock** (`DummyData`, corpus-derived) | none yet — `DocsRemoteDataSource` is scaffolded |
| Contribution | **Mock** (stores in `shared_preferences`, logs) | none yet |
| Map / wilayas | **Static** list of 58 wilayas | none needed |

## Pointing at a real backend

Base URLs are centralized in `lib/core/constants/end_points.dart` and read from `.env`:

```dotenv
# .env  (copy from .env.example)
AUTH_BASE_URL=http://10.0.2.2:3000   # Node/Express (cultini-backend)
AI_BASE_URL=http://10.0.2.2:8000     # FastAPI (cultini_AI)
```

- `10.0.2.2` is the host machine from the **Android emulator**. Use `http://localhost` for the
  iOS simulator / desktop, or your machine's LAN IP for a physical device.
- The default `ApiClient` targets `AUTH_BASE_URL`; a second named instance (`instanceName: 'ai'`)
  targets `AI_BASE_URL` and is injected into the chat datasource.
- To enable a future Documentation endpoint: add its path to `EndPoints`, implement
  `DocsRemoteDataSource.getEntries`, and have `DocsRepositoryImpl` prefer remote (online-first)
  with the local mock as fallback.

## Running

```bash
flutter pub get
flutter run            # emulator / device   (use -d chrome for web)
flutter analyze        # static analysis — currently clean
```

Auth and chat require their backends running (start `cultini-backend` on :3000 and
`cultini_AI` on :8000, then set the base URLs above). Map, Documentation, and Contribution
work fully offline on mock data. The OSM basemap needs network to render tiles; wilaya markers
are tappable regardless.

> **Note:** `flutter test` cannot run while the project sits under a path containing an
> apostrophe (`…/Github Repo's/…`) — Flutter's generated test listener embeds the path in a
> single-quoted string and the apostrophe breaks it. The tests in `test/cultini_test.dart`
> are valid (covered by `flutter analyze`) and pass once the project is in an apostrophe-free path.
