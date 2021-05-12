<a id="blockcart-header" href="{$link->getPageLink($order_process, true)|escape:'html':'UTF-8'}" title="{l s='View Cart' mod='blockcart'}" rel="nofollow">
    <div class="blockcart-icon">
        <i class="fa fa-cart"></i>
    </div>

    <div class="blockcart-title">
        <span>{l s='Cart' mod='blockcart'}</span>
    </div>

    <span id="CartTotal" class="ajax_cart_total">
        {if $priceDisplay == 1}
            {assign var='blockcart_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
            {convertPrice price=$cart->getOrderTotal(false, $blockcart_cart_flag)}
        {else}
            {assign var='blockcart_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
            {convertPrice price=$cart->getOrderTotal(true, $blockcart_cart_flag)}
        {/if}

    </span>
    {if $cart_qties == 0}
    <span class="ajax_cart_no_product">{l s='(empty)' mod='blockcart'}</span>
    {/if}
</a>
