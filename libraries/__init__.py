"""
Android Auto Test Framework - CAN Bus Simulator Library

Simulates CAN bus messages for infotainment testing.
CAN IDs: 0x100=Media, 0x200=Voice, 0x300=BT, 0x400=Nav, 0x500=System
"""

import time
import random
from typing import Dict, List, Optional


# CAN ID Reference:
# 0x100: Media (41 01=Play, 41 02=Pause, 41 03=Stop)
# 0x200: Voice (51 01=ON, 51 00=OFF)
# 0x300: BT (61 01=Connected, 61 00=Disconnected)
# 0x400: Nav (71 01=Active, 71 00=Inactive)


# Represents a single CAN bus message (ID, data, timestamp).
class CANSIMessage:
    # Initialize CAN message with ID, data, and optional timestamp.
    def __init__(self, can_id: str, data: bytes, timestamp: float = None):
        self.can_id = can_id
        self.data = data
        self.timestamp = timestamp or time.time()

    # Return human-readable string representation.
    def __str__(self):
        return f"CAN[{self.can_id}]: {self.data.hex()}"


# Simulates CAN bus communication. Tracks message history and vehicle state.
class CANSimulator:
    # Initialize CAN simulator with default vehicle state.
    def __init__(self):
        self.message_history: List[CANSIMessage] = []
        self.subscribers: Dict[str, callable] = {}
        self._is_connected = False
        self._current_state: Dict[str, any] = {
            "media_state": "stopped",
            "voice_active": False,
            "bluetooth_connected": False,
            "navigation_active": False,
            "call_active": False
        }

    # Connect to CAN bus. Idempotent - safe to call if already connected.
    def connect(self) -> bool:
        if self._is_connected:
            return True
        self._is_connected = True
        self._log_message("SYSTEM", "CAN bus connected")
        return True

    # Disconnect from CAN bus. send_message() will raise after disconnect.
    def disconnect(self):
        self._is_connected = False
        self._log_message("SYSTEM", "CAN bus disconnected")

    # Reset to initial state: clear history, reset state, disconnect.
    def reset(self):
        self.message_history.clear()
        self._is_connected = False
        self._current_state = {
            "media_state": "stopped",
            "voice_active": False,
            "bluetooth_connected": False,
            "navigation_active": False,
            "call_active": False
        }

    # Send CAN message: validates, stores, updates state. Raises if not connected.
    def send_message(self, can_id: str, data: bytes) -> bool:
        if not self._is_connected:
            raise RuntimeError("CAN bus not connected. Call connect() first.")
        message = CANSIMessage(can_id, data)
        self.message_history.append(message)
        self._update_state(can_id, data)
        return True

    # Parse CAN message and update vehicle state based on message content.
    def _update_state(self, can_id: str, data: bytes):
        data_str = data.hex()

        # Media: 41 01=Play, 41 02=Pause, 41 03=Stop
        if "41" in data_str:
            if "01" in data_str:
                self._current_state["media_state"] = "playing"
            elif "02" in data_str:
                self._current_state["media_state"] = "paused"
            elif "03" in data_str:
                self._current_state["media_state"] = "stopped"

        # Voice: 51 01=ON, 51 00=OFF
        elif "51" in data_str:
            if "01" in data_str:
                self._current_state["voice_active"] = True
            elif "00" in data_str:
                self._current_state["voice_active"] = False

        # BT: 61 01=Connected, 61 00=Disconnected
        elif "61" in data_str:
            if "01" in data_str:
                self._current_state["bluetooth_connected"] = True
            elif "00" in data_str:
                self._current_state["bluetooth_connected"] = False

        # Nav: 71 01=Active, 71 00=Inactive
        elif "71" in data_str:
            if "01" in data_str:
                self._current_state["navigation_active"] = True
            elif "00" in data_str:
                self._current_state["navigation_active"] = False

    # Get most recent CAN message for given ID, or None if not found.
    def get_last_message(self, can_id: str) -> Optional[CANSIMessage]:
        messages = [m for m in self.message_history if m.can_id == can_id]
        return messages[-1] if messages else None

    # Get all CAN messages for an ID since a specific timestamp.
    def get_messages_since(self, can_id: str, timestamp: float) -> List[CANSIMessage]:
        return [
            m for m in self.message_history
            if m.can_id == can_id and m.timestamp >= timestamp
        ]

    # Get snapshot of current vehicle state.
    def get_current_state(self) -> Dict[str, any]:
        return self._current_state.copy()

    # Assert state variable matches expected. Raises AssertionError if not.
    def verify_state(self, key: str, expected_value: any) -> bool:
        actual = self._current_state.get(key)
        if actual != expected_value:
            raise AssertionError(
                f"State verification failed for '{key}': "
                f"expected '{expected_value}', got '{actual}'"
            )
        return True

    # Internal: Log system message to history.
    def _log_message(self, can_id: str, message: str):
        self.message_history.append(CANSIMessage(can_id, message.encode()))

    # Clear all CAN message history.
    def clear_history(self):
        self.message_history.clear()

    # Get total number of CAN messages sent.
    def get_message_count(self) -> int:
        return len(self.message_history)


# Global simulator instance - shared across all test cases
_simulator = CANSimulator()


# Robot Framework Keywords - exposed as test keywords
# Connect to CAN bus. Must be called before other CAN operations.
def connect_to_can_bus():
    return _simulator.connect()


# Disconnect from CAN bus.
def disconnect_from_can_bus():
    _simulator.disconnect()


# Reset simulator: clear history, reset state, disconnect.
def reset_can_simulator():
    _simulator.reset()


# Send CAN message with given ID and hex data.
def send_can_message(can_id: str, data: str):
    hex_str = data.replace(" ", "")
    data_bytes = bytes.fromhex(hex_str)
    return _simulator.send_message(can_id, data_bytes)


# Verify media playback state: stopped, playing, paused. Raises if mismatch.
def verify_media_state(state: str):
    return _simulator.verify_state("media_state", state)


# Verify voice assistant state. Raises if mismatch.
def verify_voice_active(active: bool):
    return _simulator.verify_state("voice_active", active)


# Verify Bluetooth connection state. Raises if mismatch.
def verify_bluetooth_connected(connected: bool):
    return _simulator.verify_state("bluetooth_connected", connected)


# Verify navigation state. Raises if mismatch.
def verify_navigation_active(active: bool):
    return _simulator.verify_state("navigation_active", active)


# Get all current vehicle states as dict.
def get_current_vehicle_state():
    return _simulator.get_current_state()


# Verify most recent CAN message for ID contains expected hex data. Raises if not found or mismatch.
def can_message_should_contain(can_id: str, expected_data: str):
    message = _simulator.get_last_message(can_id)
    if not message:
        raise AssertionError(f"No CAN message found for ID {can_id}")
    actual_data = message.data.hex().lower()
    expected_hex = expected_data.replace(" ", "").lower()
    if expected_hex not in actual_data:
        raise AssertionError(
            f"CAN message data mismatch for ID {can_id}: "
            f"expected '{expected_hex}' to be contained in '{actual_data}'"
        )
    return True


# Clear all CAN message history.
def clear_can_history():
    _simulator.clear_history()


# Log current CAN bus state for debugging. Returns state dict.
def log_can_state():
    state = _simulator.get_current_state()
    print(f"\n=== CURRENT VEHICLE STATE ===")
    print(f"Media:      {state['media_state']}")
    print(f"Voice:      {'Active' if state['voice_active'] else 'Inactive'}")
    print(f"Bluetooth:  {'Connected' if state['bluetooth_connected'] else 'Disconnected'}")
    print(f"Navigation: {'Active' if state['navigation_active'] else 'Inactive'}")
    print(f"Total CAN messages: {_simulator.get_message_count()}")
    print(f"================================\n")
    return state


# API Testing Keywords - simulate REST API calls for telemetry testing


# Mock HTTP response with status_code and json_body.
class APIResponse:
    # Initialize with status code and JSON body.
    def __init__(self, status_code: int, json_body):
        self.status_code = status_code
        self._json_body = json_body

    # Return JSON body.
    def json(self):
        return self._json_body


# Get vehicle state for API responses.
def _get_api_vehicle_state():
    return _simulator.get_current_state()


# Simulate GET request. Returns APIResponse with status_code and json().
def get_request(endpoint: str):
    if endpoint == "/api/v1/vehicle/status":
        state = _get_api_vehicle_state()
        return APIResponse(200, {
            "status": "online",
            "timestamp": time.time(),
            "bluetooth_connected": state["bluetooth_connected"],
            "media_state": state["media_state"],
            "voice_active": state["voice_active"],
            "navigation_active": state["navigation_active"],
            "call_active": state["call_active"]
        })
    elif endpoint == "/api/v1/media/state":
        state = _get_api_vehicle_state()
        return APIResponse(200, {
            "playback_state": state["media_state"],
            "current_track": None,
            "position": 0
        })
    elif endpoint == "/api/v1/bluetooth/status":
        state = _get_api_vehicle_state()
        return APIResponse(200, {
            "connected": state["bluetooth_connected"],
            "paired_devices": ["Phone"] if state["bluetooth_connected"] else []
        })
    elif endpoint == "/api/v1/navigation/route":
        state = _get_api_vehicle_state()
        return APIResponse(200, {
            "active": state["navigation_active"],
            "destination": "Home" if state["navigation_active"] else None,
            "waypoints": ["Home"] if state["navigation_active"] else []
        })
    else:
        return APIResponse(404, {"error": "Not found"})


# Simulate POST request with JSON payload. Returns APIResponse.
def post_request(endpoint: str, payload: dict):
    if endpoint == "/api/v1/media/control":
        command = payload.get("command", "")
        if command == "play":
            _simulator.send_message("0x100", bytes.fromhex("41 01"))
        elif command == "pause":
            _simulator.send_message("0x100", bytes.fromhex("41 02"))
        elif command == "stop":
            _simulator.send_message("0x100", bytes.fromhex("41 03"))
        return APIResponse(200, {"status": "success", "command": command})

    elif endpoint == "/api/v1/navigation/destination":
        if "destination" not in payload and "latitude" not in payload:
            return APIResponse(400, {"error": "Invalid payload"})
        destination = payload.get("destination", "Unknown")
        _simulator.send_message("0x400", bytes.fromhex("71 01"))
        return APIResponse(200, {"status": "confirmed", "destination": destination})

    elif endpoint == "/api/v1/telemetry/data":
        return APIResponse(201, {"collected": True, "id": int(time.time())})

    elif endpoint == "/api/v1/telemetry/batch":
        entries = payload.get("entries", [])
        return APIResponse(201, {"collected": True, "collected_count": len(entries)})

    else:
        return APIResponse(404, {"error": "Not found"})


# Assert response status code matches expected. Raises if mismatch.
def status_should_be(expected: int, response: APIResponse):
    if response.status_code != expected:
        raise AssertionError(
            f"Status code mismatch: expected {expected}, got {response.status_code}"
        )
