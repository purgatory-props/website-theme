{if isset($blockcart_top) && $blockcart_top}
<div id="blockcart-container">
    <div id="blockcart" class="shopping_cart">
        {include file='./includes/header.tpl'}

    </div>

    {if !$PS_CATALOG_MODE}
        {include file='./includes/dropdown.tpl'}
    {/if}
</div>
{/if}
