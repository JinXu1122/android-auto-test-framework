# Android Auto Test Automation Framework

A Robot Framework-based test automation framework for validating Android Auto / CarPlay infotainment systems by simulating CAN bus messages.

## 🎯 Purpose

This framework enables QA engineers to test Android Auto functionality by simulating the CAN bus messages that would be sent between an Android Auto head unit and vehicle ECUs (Electronic Control Units). This allows for automated testing without requiring a physical vehicle or hardware-in-the-loop (HIL) setup.

## 📋 Test Coverage

| Test Suite | Description |
|------------|-------------|
| `media_playback.robot` | Media play/pause/stop, track navigation |
| `voice_command.robot` | Voice assistant activation/deactivation |
| `bluetooth.robot` | BT pairing, connection, disconnection |
| `navigation.robot` | Navigation start/stop, route guidance |
| `integration.robot` | End-to-end multi-feature workflows |

## 🛠 Technology Stack

| Component | Technology |
|-----------|------------|
| Test Framework | Robot Framework 6.1.1 |
| Language | Python 3.8+ |
| CAN Simulation | Custom `can_lib` library |
| CI/CD | GitHub Actions |
| Version Control | Git |

## 🚀 Quick Start

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/android-auto-test-framework.git
cd android-auto-test-framework

# Install dependencies
pip install -r requirements.txt
```

### Run Tests

```bash
# Run all tests
robot tests/

# Run specific test suite
robot tests/media_playback.robot

# Run with detailed output
robot --outputdir ./results tests/
```

## 📁 Project Structure

```
android-auto-test-framework/
├── .github/
│   └── workflows/
│       └── robot-tests.yml      # CI/CD pipeline
├── libraries/
│   └── __init__.py              # CAN simulator library
├── tests/
│   ├── media_playback.robot     # Media tests
│   ├── voice_command.robot      # Voice assistant tests
│   ├── bluetooth.robot          # Bluetooth tests
│   ├── navigation.robot         # Navigation tests
│   └── integration.robot        # Integration tests
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

## 📖 Example Test

```robot
*** Test Cases ***
Verify Media Playback
    Connect To Can Bus
    Clear Can History

    # Send Play command
    Send Can Message    0x100    41 01

    # Verify media is playing
    Verify Media State    playing

    # Verify CAN message was sent
    Can Message Should Contain    0x100    41
```

## 🔗 CI/CD

Tests run automatically on:
- Every push to main/master
- Every pull request

View the latest test results in the GitHub Actions tab.

## 📝 Key Features

- **CAN Bus Simulation**: Mocks real vehicle CAN communication
- **Keyword-Driven**: Easy-to-read Robot Framework syntax
- **Modular Design**: Separate test suites per feature
- **CI/CD Ready**: GitHub Actions integration
- **Detailed Logging**: Comprehensive test reports and logs

## 🎓 For Interview Preparation

This project demonstrates:

1. **Test Automation Skills**: Robot Framework expertise
2. **Automotive Knowledge**: Understanding of CAN bus, infotainment systems
3. **Framework Development**: Building custom test libraries in Python
4. **CI/CD Pipeline**: GitHub Actions for automated testing
5. **Integration Testing**: End-to-end multi-component scenarios

## 📄 License

MIT License
