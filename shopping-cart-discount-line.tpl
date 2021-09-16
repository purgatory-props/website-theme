<div class="sc-discount text-success clearfix" id="cart_discount_{$discount.id_discount}">
    <div class="sc-discount-name text-center">
        {$discount.name}
    </div>

    <div class="sc-discount-spacing1"></div>

    <div class="sc-discount-amount">
         {if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}
    </div>

    <div class="sc-discount-removal text-center" {if !strlen($discount.code)}style="height: 1px"{/if}>
        {if strlen($discount.code)}
            <a
                href="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}?deleteDiscount={$discount.id_discount}"
                class="price_discount_delete"
                title="{l s='Delete'}">
                <i class="icon icon-trash"></i>
            </a>
        {/if}
    </div>

    <div class="sc-discount-total text-right">
        {if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}
    </div>
</div>