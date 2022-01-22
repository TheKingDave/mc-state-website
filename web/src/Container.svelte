<div class="container">
    <slot></slot>
</div>

<style>
    .container {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: nowrap;
        max-width: 400px;
        width: 100%;
        margin-left: auto;
        margin-right: auto;
        padding-left: .75rem;
        padding-right: .75rem;
    }
</style>