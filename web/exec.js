// Function to check whether the PWA application is installed
function checkPWAInstallation() {
    // Check if the standalone property is available in the navigator object
    if ('standalone' in navigator) {
        return navigator.standalone;
    } else {
        // If the standalone property is not available, assume PWA is not installed
        return false;
    }
}
// Function to get the value of a meta tag by name
function getMetaContentByName(name) {
    const metaTags = document.getElementsByTagName('meta');
    for (let i = 0; i < metaTags.length; i++) {
        if (metaTags[i].getAttribute('name') === name) {
            return metaTags[i].getAttribute('content');
        }
    }
    return null; // Return null if meta tag not found
}

// Function to get the roomId from the meta tag
function getRoomIdMeta() {
    const roomId = getMetaContentByName('roomId');
    return roomId;
}

// Function to set the "roomId" meta tag
function setRoomIdMeta() {
    const roomId = getQueryParam('roomId');
    if (roomId) {
        const metaTag = document.createElement('meta');
        metaTag.name = 'roomId';
        metaTag.content = roomId;
        document.head.appendChild(metaTag);
    }
}

// Function to get the value of a query parameter from the URL
function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

// Run the function when the page loads
window.onload = function () {
    setRoomIdMeta();
    const roomIdFromMeta = getRoomIdMeta();
    if (roomIdFromMeta) {
        console.log("Room ID from meta tag:", roomIdFromMeta);
        // You can do whatever you want with the roomIdFromMeta value here.
    }
};