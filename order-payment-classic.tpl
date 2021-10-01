<div id="order-payment-page" class="paiement_block">
  <div id="HOOK_TOP_PAYMENT">{$HOOK_TOP_PAYMENT}</div>
  {if $HOOK_PAYMENT}
    {if !$opc}
      <div id="order-detail-content" class="shopping-cart slim">
        {* Labels *}
        <div class="shopping-cart-labels">
          <label class="sc-product-image">{l s='Image'}</label>
          <label class="sc-product-details">{l s='Product'}</label>
          {if $PS_STOCK_MANAGEMENT}
            <label class="sc-product-availability">{l s='Availability'}</label>
          {/if}
          <label class="sc-product-price">{l s='Price'}</label>
          <label class="sc-product-quantity text-center">{l s='Quantity'}</label>
          <label class="sc-product-removal">{l s='Remove'}</label>
          <label class="sc-product-line-total text-right">{l s='Total'}</label>
        </div>

        {* Products *}
        {foreach $products as $product}
          {if $product.is_virtual == 0}
            {assign var='have_non_virtual_products' value=true}
          {/if}
          {assign var='productId' value=$product.id_product}
          {assign var='productAttributeId' value=$product.id_product_attribute}
          {assign var='quantityDisplayed' value=0}
          {assign var='odd' value=($odd+1)%2}
          {assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId) || count($gift_products)}
          {assign var='cannotModify' value=1}
          {assign var='noDeleteButton' value=1}

          {* Display the product line *}
          {include file="$tpl_dir./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first}
        {/foreach}

        {* Gifts *}
        {foreach $gift_products as $product}
          {assign var='productId' value=$product.id_product}
          {assign var='productAttributeId' value=$product.id_product_attribute}
          {assign var='quantityDisplayed' value=0}
          {assign var='odd' value=($product@iteration+$last_was_odd)%2}
          {assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId)}
          {assign var='cannotModify' value=1}

          {* Display the gift product line *}
          {include file="$tpl_dir./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first}
        {/foreach}

        {* Discounts *}
        {if sizeof($discounts)}
          {foreach $discounts as $discount}
            {if ($discount.value_real|floatval == 0 && $discount.free_shipping != 1) || ($discount.value_real|floatval == 0 && $discount.code == '')}
              {continue}
            {/if}

            {include file="$tpl_dir./shopping-cart-discount-line.tpl" discount=$discount}
          {/foreach}
        {/if}

        {* Totals *}
        <div class="sc-totals">
          {* Item Total *}
          {if $priceDisplay}
            <div class="totals-item">
              <label>{l s='Item Total'}</label>
              <div class="totals-value" id="total_product">{displayPrice price=$total_products}</div>
            </div>
          {/if}

          {* Gift Wrapping Total *}
          {if $total_wrapping > 0}
            <div class="totals-item">
              <label>{l s='Gift Wrapping'}</label>
              <div class="totals-value" id="cart-wrapping-total">
                {if $use_taxes}
                  {if $priceDisplay}
                    {displayPrice price=$total_wrapping_tax_exc}
                  {else}
                    {displayPrice price=$total_wrapping}
                  {/if}
                {else}
                  {displayPrice price=$total_wrapping_tax_exc}
                {/if}
              </div>
            </div>
          {/if}

          {* Discount Total *}
          {if $total_discounts > 0}
            <div class="totals-item text-success">
              <label>{l s='Discounts'}</label>
              <div class="totals-value" id="total_discount">
                {if $use_taxes && $priceDisplay == 0}
                  {assign var='total_discounts_negative' value=$total_discounts * -1}
                {else}
                  {assign var='total_discounts_negative' value=$total_discounts_tax_exc * -1}
                {/if}
                {displayPrice price=$total_discounts_negative}
              </div>
            </div>
          {/if}

          {* Tax *}
          {if $use_taxes && $show_taxes && $total_tax != 0 }
            <div class="totals-item">
              <label>{l s='Tax'}</label>
              <div class="totals-value" id="total_tax">{displayPrice price=$total_tax}</div>
            </div>
          {/if}

          {* Shipping *}
          <div class="totals-item">
            <label>{l s='Shipping'}</label>
            <div class="totals-value" id="cart-shipping-total">
              {if $total_shipping_tax_exc <= 0 && (!isset($isVirtualCart) || !$isVirtualCart) && $free_ship}
                {l s='Free!'}
              {else}
                {if $use_taxes && $total_shipping_tax_exc != $total_shipping}
                  {if $priceDisplay}
                    {displayPrice price=$shippingCostTaxExc}
                  {else}
                    {displayPrice price=$shippingCost}
                  {/if}
                {else}
                  {displayPrice price=$shippingCostTaxExc}
                {/if}
              {/if}
            </div>
          </div>

          {* Subtotal *}
          <div class="totals-item color-accent cart-subtotal">
            <label>{l s='Order Total'}</label>
            <div class="totals-value" id="total_price">{displayPrice price=$total_price}</div>
          </div>
        </div>
      </div>
    {/if}

    {if $opc}
      <div id="opc_payment_methods-content">
    {/if}

    <div id="HOOK_PAYMENT">
      {$HOOK_PAYMENT}
    </div>

    {if $opc}
      </div>
    {/if}
  {else}
    <div class="alert alert-warning">{l s='No payment modules have been installed.'}</div>
  {/if}

  {if !$opc}
    <p class="cart_navigation clearfix">
      <a href="{$link->getPageLink('order', true, NULL, "step=2")|escape:'html':'UTF-8'}" title="{l s='Previous'}" class="btn btn-lg btn-default full-width-mobile text-center" style="margin-left: 0">
        <i class="icon icon-chevron-left"></i>
        {l s='Back to Shipping'}
      </a>
    </p>
  {else}
    </div>
  {/if}
</div> {* end HOOK_TOP_PAYMENT *}
