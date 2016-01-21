import QtQuick 2.3
import QtQuick.Controls 1.2
import QtWebSockets 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    WebSocket {
        id: socket
        url: "ws://localhost:1337"
        onTextMessageReceived: {
            messageBox.text = messageBox.text + "\nReceived message: " + JSON.parse(message).foo
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                             socket.sendTextMessage(JSON.stringify({foo: 'fofo', bar: "barbar"}))
                         } else if (socket.status == WebSocket.Closed) {
                             messageBox.text += "\nSocket closed"
                         }
        active: false
    }

    WebSocket {
        id: secureWebSocket
        url: "wss://echo.websocket.org"
        onTextMessageReceived: {
            messageBox.text = messageBox.text + "\nReceived secure message: " + message
        }
        onStatusChanged: if (secureWebSocket.status == WebSocket.Error) {
                             console.log("Error: " + secureWebSocket.errorString)
                         } else if (secureWebSocket.status == WebSocket.Open) {
                             secureWebSocket.sendTextMessage("Hello Secure World")
                         } else if (secureWebSocket.status == WebSocket.Closed) {
                             messageBox.text += "\nSecure socket closed"
                         }
        active: false
    }

    Label {
        id: messageBox
        text: socket.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            socket.active = !socket.active
            //secureWebSocket.active =  !secureWebSocket.active;
        }
    }
}

