<div id="order-page">
{capture name=path}{l s='Your Cart'}{/capture}

<h1 id="cart_title" class="page-heading">{l s='Your Cart'}
  {if !isset($empty) && !$PS_CATALOG_MODE}
    <div class="pull-right">
      <span class="heading-counter badge">
        <span id="summary_products_quantity" class="small">{$productNumber} {if $productNumber == 1}{l s='Product'}{else}{l s='Products'}{/if}</span>
      </span>
    </div>
  {/if}
</h1>
{hook h='displayCartTop'}
{if isset($account_created)}
  <div class="alert alert-success">
    {l s='Your account has been created.'}
  </div>
{/if}

{assign var='current_step' value='summary'}
{include file="$tpl_dir./order-steps.tpl"}
{include file="$tpl_dir./errors.tpl"}

{if isset($empty)}
  <div class="alert alert-warning">{l s='There are no items in your cart.'}</div>
{elseif $PS_CATALOG_MODE}
  <div class="alert alert-warning">{l s='This store has not accepted your new order.'}</div>
{else}
  <div id="emptyCartWarning" class="alert alert-warning unvisible">{l s='There are no items in your cart.'}</div>

  {* if isset($lastProductAdded) AND $lastProductAdded}
    <div class="cart_last_product" style="display: none;">
      <div class="cart_last_product_header">
        <div class="left">{l s='Last product added'}</div>
      </div>
      <a class="cart_last_product_img" href="{$link->getProductLink($lastProductAdded.id_product, $lastProductAdded.link_rewrite, $lastProductAdded.category, null, null, $lastProductAdded.id_shop)|escape:'html':'UTF-8'}">
        <img src="{$link->getImageLink($lastProductAdded.link_rewrite, $lastProductAdded.id_image, 'small')|escape:'html':'UTF-8'}" alt="{$lastProductAdded.name|escape:'html':'UTF-8'}">
      </a>
      <div class="cart_last_product_content">
        <p class="product-name">
          <a href="{$link->getProductLink($lastProductAdded.id_product, $lastProductAdded.link_rewrite, $lastProductAdded.category, null, null, null, $lastProductAdded.id_product_attribute)|escape:'html':'UTF-8'}">
            {$lastProductAdded.name|escape:'html':'UTF-8'}
          </a>
        </p>
        {if isset($lastProductAdded.attributes) && $lastProductAdded.attributes}
          <small>
            <a href="{$link->getProductLink($lastProductAdded.id_product, $lastProductAdded.link_rewrite, $lastProductAdded.category, null, null, null, $lastProductAdded.id_product_attribute)|escape:'html':'UTF-8'}">
              {$lastProductAdded.attributes|escape:'html':'UTF-8'}
            </a>
          </small>
        {/if}
      </div>
    </div>
  {/if *}

  {assign var='total_discounts_num' value="{if $total_discounts != 0}1{else}0{/if}"}
  {assign var='use_show_taxes' value="{if $use_taxes && $show_taxes}2{else}0{/if}"}
  {assign var='total_wrapping_taxes_num' value="{if $total_wrapping != 0}1{else}0{/if}"}

  {* eu-legal *}
  {hook h="displayBeforeShoppingCartBlock"}

  <div id="order-detail-content" class="shopping-cart">
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
      {if isset($odd)}
        {assign var='odd' value=($odd+1)%2}
      {/if}
      {assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId) || count($gift_products)}

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
    <div class="sc-totals clearfix">
      <div class="sc-totals-right">
        {* Item Total *}
        {if $priceDisplay}
          <div class="totals-item">
            <label>{l s='Item Total'}</label>
            <div class="totals-value" id="cart-item-total">{displayPrice price=$total_products}</div>
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
            <div class="totals-value" id="cart-discount-total">
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
            <div class="totals-value" id="cart-tax-total">{displayPrice price=$total_tax}</div>
          </div>
        {/if}

        {* Subtotal *}
        <div class="totals-item color-accent cart-subtotal">
          <label>{l s='Subtotal'}</label>
          <div class="totals-value" id="cart-subtotal">{displayPrice price=$total_price}</div>
        </div>
      </div>

      <div class="sc-totals-left">
        {if $voucherAllowed}
          <form action="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}" method="post" id="voucher">
            <fieldset>
              <h4 style="margin-bottom: 0">{l s='Add Promo Codes'}</h4>
              <input type="text" class="discount_name form-control half-width uppercase" id="discount_name" autocomplete="off" name="discount_name" value="{if isset($discount_name) && $discount_name}{$discount_name}{/if}">
              <input type="hidden" name="submitDiscount">
              <button type="submit" name="submitAddDiscount" class="btn btn-primary"><span>{l s='Add'}</span></button>
            </fieldset>
          </form>

          {if $displayVouchers}
            <p id="title" class="title-offers">{l s='Take advantage of our exclusive offers:'}</p>
            <div id="display_cart_vouchers">
              {foreach $displayVouchers as $voucher}
                {$voucher.name}{if $voucher.code != ''}<span class="voucher_name" data-code="{$voucher.code|escape:'html':'UTF-8'}">&nbsp;(Use Code <span style="font-family: monospace">{$voucher.code|escape:'html':'UTF-8'}</span>)</span>{/if}<br>
              {/foreach}
            </div>
          {/if}
        {/if}
      </div>

    </div>
  </div>


  {if $show_option_allow_separate_package}
    <div class="checkbox">
      <label for="allow_seperated_package" class="inline">
        <input type="checkbox" name="allow_seperated_package" id="allow_seperated_package" {if $cart->allow_seperated_package}checked="checked"{/if} autocomplete="off">
        <span class="label-text">{l s='Ship Available Products First'}</span>
      </label>
    </div>
  {/if}

  {* Define the style if it doesn't exist in the PrestaShop version*}
  {* Will be deleted for 1.5 version and more *}
  {if !isset($addresses_style)}
    {$addresses_style.company = 'address_company'}
    {$addresses_style.vat_number = 'address_company'}
    {$addresses_style.firstname = 'address_name'}
    {$addresses_style.lastname = 'address_name'}
    {$addresses_style.address1 = 'address_address1'}
    {$addresses_style.address2 = 'address_address2'}
    {$addresses_style.city = 'address_city'}
    {$addresses_style.country = 'address_country'}
    {$addresses_style.phone = 'address_phone'}
    {$addresses_style.phone_mobile = 'address_phone_mobile'}
    {$addresses_style.alias = 'address_title'}
  {/if}

  <div id="HOOK_SHOPPING_CART">{$HOOK_SHOPPING_CART}</div>

  <p class="cart_navigation clearfix">
    {if !$opc}
      {if $is_logged}
        {assign var='nextStepName' value='Proceed to Address'}
      {else}
        {assign var='nextStepName' value='Proceed to Checkout'}
      {/if}
      <a href="{if $back}{$link->getPageLink('order', true, NULL, 'step=1&amp;back={$back}')|escape:'html':'UTF-8'}{else}{$link->getPageLink('order', true, NULL, 'step=1')|escape:'html':'UTF-8'}{/if}"
          class="btn btn-lg btn-success pull-right standard-checkout btn-full full-width-mobile text-center" style="margin-right: 0" title="{$nextStepName}">
        <span>{$nextStepName} <i class="icon icon-chevron-right"></i></span>
      </a>
    {/if}
    {*
    <a href="{if (isset($smarty.server.HTTP_REFERER) && ($smarty.server.HTTP_REFERER == $link->getPageLink('order', true) || $smarty.server.HTTP_REFERER == $link->getPageLink('order-opc', true) || strstr($smarty.server.HTTP_REFERER, 'step='))) || !isset($smarty.server.HTTP_REFERER)}{$link->getPageLink('index')}{else}{$smarty.server.HTTP_REFERER|regex_replace:'/[\?|&]content_only=1/':''|escape:'html':'UTF-8'|secureReferrer}{/if}"
       class="btn btn-lg btn-default btn-full full-width-mobile text-center" title="{l s='Continue Shopping'}" style="margin-left: 0">
      <i class="icon icon-chevron-left"></i> {l s='Continue Shopping'}
    </a>
    *}
  </p>
  <div class="clear"></div>
  <div class="cart_navigation_extra">
    <div id="HOOK_SHOPPING_CART_EXTRA">{if isset($HOOK_SHOPPING_CART_EXTRA)}{$HOOK_SHOPPING_CART_EXTRA}{/if}</div>
  </div>
  {strip}
    {addJsDef deliveryAddress=$cart->id_address_delivery|intval}
    {addJsDefL name=txtProduct}{l s='product' js=1}{/addJsDefL}
    {addJsDefL name=txtProducts}{l s='products' js=1}{/addJsDefL}
  {/strip}
{/if}

</div>