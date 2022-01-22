<script lang="ts">
    import Players from "./Players.svelte";
    import {state} from "./store";
    import Container from "./Container.svelte";

    let main;

    state.subscribe((status) => {
        main?.style.setProperty('--color-status', `var(--color-${status.state})`)
    })

</script>

<main bind:this={main}>
    <div class="header">
        <Container>
            <div>{$state.modt ?? ''}</div>
            <div class="state">{$state.state}</div>
        </Container>
    </div>

    {#if $state.state === 'online'}
        <Container>
            <Players/>
        </Container>
    {/if}
</main>

<style>
    main {
        width: 100%;
        --color-status: var(--color-unknown);
    }

    .header {
        background-color: var(--color-status);
        height: 56px;
        width: 100%;
        display: flex;

        margin-bottom: 1rem;
    }

    .state {
        text-transform: capitalize;
    }
</style>