let mapExport = prompt('Enter exported map data:');
let newWin = window.open("/", "_blank");

if (newWin == null) {
    alert("Couldn't open window");
} else {
    // Fill map data
    newWin.localStorage.setItem("custToLoad", mapExport);

    let script = newWin.document.createElement('script');
    let scriptContents = document.createTextNode(`
        function host() {
            // Set game time to zero
            document.getElementById('customSgameTime').value = '0';

            // Set game to private
            document.getElementById('makePrivate').click();

            // Start server
            document.getElementById('menuWindow').getElementsByClassName('menuLink')[1].click();
        }

        // Wait until the host menu is open
        function timeout() {
            setTimeout(function () {
                if (document.getElementById('customSgameTime') == null) {
                    console.log('Waiting for host menu to open');
                    timeout();
                } else {
                    console.log('Hosting');
                    host();
                }
            }, 1000);
        }

        timeout();
    `);
    script.appendChild(scriptContents); 
    newWin.document.head.appendChild(script);
}
