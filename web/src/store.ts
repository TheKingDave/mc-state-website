import {readable} from "svelte/store";

interface Status {
    state: string,
    ping?: number,
    modt?: string,
    onlinePlayers?: number,
    maxPlayers?: number,
    players?: [
        {
            name: string,
            uuid: string
        }
    ]
}

const UNKNOWN: Status = {'state': 'unknown'};

export const state = readable<Status>(UNKNOWN, (set) => {
    let loc = window.location, new_uri;
    if (loc.protocol === "https:") {
        new_uri = "wss:";
    } else {
        new_uri = "ws:";
    }
    new_uri += "//" + loc.host + '/ws';

    let socket: WebSocket;

    function connect() {
        socket = new WebSocket(new_uri);

        socket.addEventListener('message', function (event) {
            const data = JSON.parse(event.data)
            console.log(data);
            set(data);
        });

        socket.addEventListener('close', () => {
            socket = null;
            set(UNKNOWN);
            connect();
        });
    }

    connect();

    return function stop() {
        socket?.close();
    }
})