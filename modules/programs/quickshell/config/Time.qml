pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "h\nmm\nss\nAP\n\nM\nd\nyy")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
