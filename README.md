## 🎯 Purpose

This framework is built to test Android Auto functionality by simulating the CAN bus messages that would be sent between an Android Auto head unit and vehicle ECUs (Electronic Control Units). 

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/JinXu1122/android-auto-test-framework.git
cd android-auto-test-framework

# Install dependencies
pip install -r requirements.txt

# Run all tests
robot tests/

# Run specific test suite
robot tests/media_playback.robot
```

## 📋 Test Coverage

| Test Suite | Description | Tests |
|------------|-------------|-------|
| `media_playback.robot` | Media play/pause/stop, track navigation | 7 |
| `voice_command.robot` | Voice assistant activation/deactivation | 5 |
| `bluetooth.robot` | BT pairing, connection, disconnection | 6 |
| `navigation.robot` | Navigation start/stop, route guidance | 5 |
| `integration.robot` | End-to-end multi-feature workflows | 5 |
| `api_testing.robot` | REST API validation | 10 |

**Total: 38 tests**

## 🛠 Technology Stack

| Component | Technology |
|-----------|------------|
| Test Framework | Robot Framework 6.1.1 |
| Language | Python 3.8+ |
| CAN Simulation | Custom library |
| API Testing | Postman + Newman |
| CI/CD | GitHub Actions |
| Version Control | Git |

## 📁 Project Structure

```
android-auto-test-framework/
├── .github/
│   └── workflows/
│       ├── robot-tests.yml      # Robot Framework CI/CD
│       └── postman-tests.yml    # Postman API CI/CD
├── libraries/
│   └── __init__.py              # CAN simulator + API keywords
├── postman/
│   └── AndroidAutoAPI.postman_collection.json
├── tests/
│   ├── media_playback.robot     # Media tests
│   ├── voice_command.robot      # Voice assistant tests
│   ├── bluetooth.robot          # Bluetooth tests
│   ├── navigation.robot         # Navigation tests
│   ├── integration.robot        # Integration tests
│   └── api_testing.robot        # API tests
├── resources/
│   └── test_setup.robot         # Shared test resources
├── requirements.txt
└── README.md
```

## 🔧 CAN Message Reference

| CAN ID | Function | Data Format |
|--------|----------|-------------|
| `0x100` | Media Control | `41 01`=Play, `41 02`=Pause, `41 03`=Stop |
| `0x200` | Voice Command | `51 01`=ON, `51 00`=OFF |
| `0x300` | Bluetooth | `61 01`=Connected, `61 00`=Disconnected |
| `0x400` | Navigation | `71 01`=Active, `71 00`=Inactive |

## 🔗 CI/CD

Tests run automatically on:
- Every push to main/master
- Every pull request
- Manual trigger (workflow_dispatch)

**Two CI/CD Pipelines:**
- `robot-tests.yml` - Runs Robot Framework tests
- `postman-tests.yml` - Runs Postman API tests via Newman


