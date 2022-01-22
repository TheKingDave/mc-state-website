<script>
    import Box from "./Box.svelte";
    import {state} from "./store";
</script>

<Box>
    <div class="title">
        <div>Players</div>
        <div>{$state.onlinePlayers}/{$state.maxPlayers}</div>
    </div>
    <ul class="list">
        {#each $state.players as player}
            <li class="entry">
                <img src="https://crafatar.com/avatars/{player.uuid}" alt="Skin of player {player.name}" />
                {player.name}
            </li>
        {:else}
            No players online
        {/each}
    </ul>
</Box>

<style>
    .title {
        line-height: 2rem;
        font-weight: 500;
        font-size: 1.25rem;

        display: flex;
        justify-content: space-between;

        margin-bottom: 16px;
    }

    .list {
        margin: 0;
        padding: 0 0;
        list-style-type: none;
    }

    .entry {
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: flex-start;
    }

    .entry > img {
        width: 40px;
        height: 40px;
        margin-right: 16px;
        margin-left: 0;
    }
</style>
