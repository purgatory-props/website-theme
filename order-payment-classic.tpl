<div class="paiement_block">
  <div id="HOOK_TOP_PAYMENT">{$HOOK_TOP_PAYMENT}</div>
  {if $HOOK_PAYMENT}
    {if !$opc}
      <div id="order-detail-content" class="table_block table-responsive">
        <table id="cart_summary" class="table table-bordered">
          <thead>
          <tr class="no-border">
            <th class="cart_product no-border">{l s='Product'}</th>
            <th class="cart_description no-border">{l s='Description'}</th>
            {if $PS_STOCK_MANAGEMENT}
              <th class="cart_availability no-border">{l s='Availability'}</th>
            {/if}
            <th class="cart_unit text-right no-border">{l s='Unit Price'}</th>
            <th class="cart_quantity text-center no-border">{l s='Qty'}</th>
            <th class="cart_total no-border">{l s='Total'}</th>
          </tr>
          </thead>
          <tfoot style="border-top: 2px solid #b8b8b8">
          {if $use_taxes}
            {if $priceDisplay}
              <tr class="cart_total_price small">
                <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{if $display_tax_label}{l s='Item Total'}{else}{l s='Item Total'}{/if}</td>
                <td colspan="1" class="price" id="total_product">{displayPrice price=$total_products}</td>
              </tr>
            {else}
              <tr class="cart_total_price small">
                <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{if $display_tax_label}{l s='Item Total'}{else}{l s='Item Total'}{/if}</td>
                <td colspan="1" class="price" id="total_product">{displayPrice price=$total_products_wt}</td>
              </tr>
            {/if}
          {else}
            <tr class="cart_total_price small">
              <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{l s='Item Total'}</td>
              <td colspan="1" class="price" id="total_product">{displayPrice price=$total_products}</td>
            </tr>
          {/if}
          <tr class="cart_total_voucher" {if $total_wrapping == 0}style="display:none"{/if}>
            <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right small">
              {l s='Gift Wrapping'}
            </td>
            <td colspan="1" class="price-discount price small text-success" id="total_wrapping">
              {if $use_taxes}
                {if $priceDisplay}
                  {displayPrice price=$total_wrapping_tax_exc}
                {else}
                  {displayPrice price=$total_wrapping}
                {/if}
              {else}
                {displayPrice price=$total_wrapping_tax_exc}
              {/if}
            </td>
          </tr>
          {if $total_shipping_tax_exc <= 0 && (!isset($isVirtualCart) || !$isVirtualCart) && $free_ship}
            <tr class="cart_total_delivery small">
              <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{l s='Shipping'}</td>
              <td colspan="1" class="price" id="total_shipping">{l s='Free Shipping!'}</td>
            </tr>
          {else}
            {if $use_taxes && $total_shipping_tax_exc != $total_shipping}
              {if $priceDisplay}
                <tr class="cart_total_delivery small" {if $shippingCost <= 0} style="display:none"{/if}>
                  <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{if $display_tax_label}{l s='Shipping'}{else}{l s='Shipping'}{/if}</td>
                  <td colspan="1" class="price" id="total_shipping">{displayPrice price=$shippingCostTaxExc}</td>
                </tr>
              {else}
                <tr class="cart_total_delivery small"{if $shippingCost <= 0} style="display:none"{/if}>
                  <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{if $display_tax_label}{l s='Shipping'}{else}{l s='Shipping'}{/if}</td>
                  <td colspan="1" class="price" id="total_shipping" >{displayPrice price=$shippingCost}</td>
                </tr>
              {/if}
            {else}
              <tr class="cart_total_delivery small"{if $shippingCost <= 0} style="display:none"{/if}>
                <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{l s='Shipping'}</td>
                <td colspan="1" class="price" id="total_shipping" >{displayPrice price=$shippingCostTaxExc}</td>
              </tr>
            {/if}
          {/if}
          <tr class="cart_total_voucher small text-success" {if $total_discounts == 0}style="display:none"{/if}>
            <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">
                {l s='Promo Codes'}
            </td>
            <td colspan="1" class="price-discount price text-success" id="total_discount">
              {if $use_taxes}
                {if $priceDisplay}
                  {displayPrice price=$total_discounts_tax_exc*-1}
                {else}
                  {displayPrice price=$total_discounts*-1}
                {/if}
              {else}
                {displayPrice price=$total_discounts_tax_exc*-1}
              {/if}
            </td>
          </tr>
          {if $use_taxes}
            {if $total_tax != 0 && $show_taxes}
              <tr class="cart_total_tax">
                <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right">{l s='Tax'}</td>
                <td colspan="1" class="price" id="total_tax" >{displayPrice price=$total_tax}</td>
              </tr>
            {/if}
            <tr class="cart_total_price color-accent bold" style="font-size: 1.3em;">
              <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="total_price_container text-right"><span>{l s='Total'}</span></td>
              <td colspan="1" class="price" id="total_price_container">
                <span id="total_price" data-selenium-total-price="{$total_price}">{displayPrice price=$total_price}</span>
              </td>
            </tr>
          {else}
            <tr class="cart_total_price color-accent bold" style="font-size: 1.3em">
              <td colspan="{if $PS_STOCK_MANAGEMENT}5{else}4{/if}" class="text-right total_price_container">
                <span>{l s='Total'}</span>
              </td>
              <td colspan="1" class="price total_price_container" id="total_price_container">
                <span id="total_price" data-selenium-total-price="{$total_price_without_tax}">{displayPrice price=$total_price_without_tax}</span>
              </td>
            </tr>
          {/if}
          </tfoot>

          <tbody>
          {foreach from=$products item=product name=productLoop}
            {assign var='productId' value=$product.id_product}
            {assign var='productAttributeId' value=$product.id_product_attribute}
            {assign var='quantityDisplayed' value=0}
            {assign var='cannotModify' value=1}
            {assign var='odd' value=$product@iteration%2}
            {assign var='noDeleteButton' value=1}

            {* Display the product line *}
            {include file="$tpl_dir./shopping-cart-product-line.tpl"}

            {* Then the customized datas ones*}
            {if isset($customizedDatas.$productId.$productAttributeId)}
              {foreach from=$customizedDatas.$productId.$productAttributeId[$product.id_address_delivery] key='id_customization' item='customization'}
                <tr id="product_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" class="cart_item no-border">
                  <td colspan="4" class="no-border">
                    {foreach from=$customization.datas key='type' item='datas'}
                      {if $type == $CUSTOMIZE_FILE}
                        <div class="customizationUploaded">
                          <ul class="customizationUploaded">
                            {foreach from=$datas item='picture'}
                              <li>
                                <img src="{$pic_dir}{$picture.value}_small" alt="" class="customizationUploaded">
                              </li>
                            {/foreach}
                          </ul>
                        </div>
                      {elseif $type == $CUSTOMIZE_TEXTFIELD}
                        <ul class="typedText">
                          {foreach from=$datas item='textField' name='typedText'}
                            <li>
                              {if $textField.name}
                                {l s='%s:' sprintf=$textField.name}
                              {else}
                                {l s='Text #%s:' sprintf=$smarty.foreach.typedText.index+1}
                              {/if}
                              {$textField.value}
                            </li>
                          {/foreach}
                        </ul>
                      {/if}
                    {/foreach}
                  </td>
                  <td class="cart_quantity text-center no-border">
                    {$customization.quantity}
                  </td>
                  <td class="cart_total no-border"></td>
                </tr>
                {assign var='quantityDisplayed' value=$quantityDisplayed+$customization.quantity}
              {/foreach}
              {* If it exists also some uncustomized products *}
              {if $product.quantity-$quantityDisplayed > 0}{include file="$tpl_dir./shopping-cart-product-line.tpl"}{/if}
            {/if}
          {/foreach}
          {assign var='last_was_odd' value=$product@iteration%2}
          {foreach $gift_products as $product}
            {assign var='productId' value=$product.id_product}
            {assign var='productAttributeId' value=$product.id_product_attribute}
            {assign var='quantityDisplayed' value=0}
            {assign var='odd' value=($product@iteration+$last_was_odd)%2}
            {assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId)}
            {assign var='cannotModify' value=1}
            {* Display the gift product line *}
            {include file="./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first}
          {/foreach}
          {if count($discounts)}
            {foreach from=$discounts item=discount name=discountLoop}
              {if $discount.value_real|floatval == 0}
                {continue}
              {/if}
              <tr class="cart_discount text-success no-border" id="cart_discount_{$discount.id_discount}">
                <td class="cart_discount_name no-border" colspan="{if $PS_STOCK_MANAGEMENT}3{else}2{/if}">{$discount.name}</td>
                <td class="cart_discount_price text-right no-border">
                  <span class="price-discount">
                    {if $discount.value_real > 0}
                      {if !$priceDisplay}
                        {displayPrice price=$discount.value_real*-1}
                      {else}
                        {displayPrice price=$discount.value_tax_exc*-1}
                      {/if}
                    {/if}
                  </span>
                </td>
                <td class="cart_discount_delete text-center no-border">1</td>
                <td class="cart_discount_price no-border">
                  <span class="price-discount">
                    {if $discount.value_real > 0}
                      {if !$priceDisplay}
                        {displayPrice price=$discount.value_real*-1}
                      {else}
                        {displayPrice price=$discount.value_tax_exc*-1}
                      {/if}
                    {/if}
                  </span>
                </td>
              </tr>
            {/foreach}
          {/if}
            </tbody>
        </table>
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
