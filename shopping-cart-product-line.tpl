{assign var='orderLaterLabel' value='Backorder'}
{assign var='orderNowLabel' value='In Stock'}

{if !ctype_space($product.available_later) && !empty($product.available_later)}
    {assign var='orderLaterLabel' value=$product.available_later}
{/if}
{if !ctype_space($product.available_now) && !empty($product.available_now)}
    {assign var='orderNowLabel' value=$product.available_now}
{/if}

{if !isset($noDeleteButton)}
  {assign var='noDeleteButton' value=false}
{/if}

{if !isset($odd)}
  {assign var='odd' value=false}
{/if}

<div class="sc-product clearfix{if !empty($product.gift)} gift{/if}" id="product_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}" class="cart_item address_{$product.id_address_delivery|intval} {if $odd}odd{else}even{/if} textlink-nostyle no-border">
  {* Product Image *}
  <div class="sc-product-image">
     <img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'medium', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
             alt="{$product.name|escape:'html':'UTF-8'}"
             width="{getWidthSize|intval type='medium'}"
             height="{getHeightSize|intval type='medium'}"
             loading="lazy"
        >
  </div>

  {* Product Name *}
  <div class="sc-product-details">
    <a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop, $product.id_product_attribute, false, false, true)|escape:'html':'UTF-8'}" class="link-nocolor">{$product.name|escape:'html':'UTF-8'}</a>
    {if $product.reference}<br/><small class="small cart_ref text-darker">{$product.reference|escape:'html':'UTF-8'}</small>{/if}

    {capture name=sep}: {/capture}
    {capture}{l s=': '}{/capture}
    {if isset($product.attributes) && $product.attributes}<br><small class="small text-darker">{$product.attributes|@replace: $smarty.capture.sep:$smarty.capture.default|escape:'html':'UTF-8'}</small>{/if}
  </div>

  {* Stock Availability *}
  {if $PS_STOCK_MANAGEMENT}
    <div class="sc-product-availability">
       <span class="label{if $product.quantity_available <= 0 && (isset($product.allow_oosp) && !$product.allow_oosp)} label-danger{else if $product.quantity_available <= 0 && (isset($product.allow_oosp) && $product.allow_oosp)} label-warning{else} label-success{/if}">
        {if $product.quantity_available <= 0}
          {if isset($product.allow_oosp) && $product.allow_oosp}
            {$orderLaterLabel}
          {else}
            {l s='Out of Stock'}
          {/if}
        {else}
          {$orderNowLabel}
        {/if}
      </span>
      {if !$product.is_virtual}{hook h="displayProductDeliveryTime" product=$product}{/if}
    </div>
  {/if}

  {* Unit Price *}
  <div class="sc-product-price">
    {if !empty($product.gift)}
      <span class="gift-icon">{l s='Gift!'}</span>
    {else}
      {if isset($product.is_discounted) && $product.is_discounted && isset($product.reduction_applies) && $product.reduction_applies}
        <span class="old-price">{convertPrice price=$product.price_without_specific_price}</span>

        <span class="price-percent-reduction small">
          {if !$priceDisplay}
            {if isset($product.reduction_type) && $product.reduction_type == 'amount'}
              {assign var='priceReduction' value=($product.price_wt - $product.price_without_specific_price)}
              {assign var='symbol' value=$currency->sign}
            {else}
              {assign var='priceReduction' value=(($product.price_without_specific_price - $product.price_wt)/$product.price_without_specific_price) * 100 * -1}
              {assign var='symbol' value='%'}
            {/if}
          {else}
            {if isset($product.reduction_type) && $product.reduction_type == 'amount'}
              {assign var='priceReduction' value=($product.price - $product.price_without_specific_price)}
              {assign var='symbol' value=$currency->sign}
            {else}
              {assign var='priceReduction' value=(($product.price_without_specific_price - $product.price)/$product.price_without_specific_price) * -100}
              {assign var='symbol' value='%'}
            {/if}
          {/if}
          {if $symbol == '%'}
            &nbsp;{$priceReduction|string_format:"%.2f"|regex_replace:"/[^\d]0+$/":""}{$symbol}&nbsp;
          {else}
            &nbsp;{convertPrice price=$priceReduction}&nbsp;
          {/if}
        </span>
      {/if}

      {if !$priceDisplay}
        <span class="price final-price small{if isset($product.is_discounted) && $product.is_discounted && isset($product.reduction_applies) && $product.reduction_applies} special-price{/if}">{convertPrice price=$product.price_wt}</span>
      {else}
        <span class="price final-price small{if isset($product.is_discounted) && $product.is_discounted && isset($product.reduction_applies) && $product.reduction_applies} special-price{/if}">{convertPrice price=$product.price}</span>
      {/if}
    {/if}
  </div>

  {* Quantity *}
  <div class="sc-product-quantity text-center">
    {if (isset($cannotModify) && $cannotModify == 1)}
      <span class="text-center">
        {if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}
          {$product.customizationQuantityTotal}
        {else}
          {$product.cart_quantity-$quantityDisplayed}
        {/if}
      </span>
    {else}
      {if isset($customizedDatas.$productId.$productAttributeId) AND $quantityDisplayed == 0}
        <span id="cart_quantity_custom_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval}" >{$product.customizationQuantityTotal}</span>
      {/if}
      {if !isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed > 0}
        <input type="hidden" value="{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}" name="quantity_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}_hidden">
        <input size="2" type="text" autocomplete="off" class="cart_quantity_input form-control text-center" style="font-size: 1.5em; outline: none; border: none" value="{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}"  name="quantity_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}">

        <div class="cart_quantity_button clearfix no-mobile">
          {if $product.minimal_quantity < ($product.cart_quantity-$quantityDisplayed) OR $product.minimal_quantity <= 1}
            <a rel="nofollow" class="cart_quantity_down btn btn-default button-minus" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;op=down&amp;token={$token_cart}")|escape:'html':'UTF-8'}" title="{l s='Subtract'}">
              <i class="icon icon-fw icon-minus"></i>
            </a>
          {else}
            <a class="cart_quantity_down btn btn-default button-minus disabled" href="#" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" title="{l s='You must purchase a minimum of %d of this product.' sprintf=$product.minimal_quantity}">
              <i class="icon icon-fw icon-minus"></i>
            </a>
          {/if}
          <a rel="nofollow" class="cart_quantity_up btn btn-default button-plus" id="cart_quantity_up_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")|escape:'html':'UTF-8'}" title="{l s='Add'}"><i class="icon icon-fw icon-plus"></i></a>
        </div>
      {/if}
    {/if}
  </div>

  {* Remove Line Item *}
  <div class="sc-product-removal text-center no-mobile">
      {if (!isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed > 0) && empty($product.gift) && !$noDeleteButton}
        <div>
          <a rel="nofollow" title="{l s='Delete'}" class="cart_quantity_delete" id="{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "delete=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")|escape:'html':'UTF-8'}"><i class="icon icon-trash"></i></a>
        </div>
      {else}
        <div style="width: 100%; height: 1px"></div>
      {/if}
  </div>

  {* Line Total *}
  <div class="sc-product-line-total text-right">
    <span class="price total-price text-right accent-color" id="total_product_price_{$product.id_product}_{$product.id_product_attribute}{if $quantityDisplayed > 0}_nocustom{/if}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}">
      {if !empty($product.gift)}
        <span>{l s='Gift!'}</span>
      {else}
        {if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}
          {if !$priceDisplay}{displayPrice price=$product.total_customization_wt}{else}{displayPrice price=$product.total_customization}{/if}
        {else}
          {if !$priceDisplay}{displayPrice price=$product.total_wt}{else}{displayPrice price=$product.total}{/if}
        {/if}
      {/if}
    </span>
  </div>

  {* Mobile Remove Button *}
  <div class="sc-product-removal no-desktop clearfix">
     {if (!isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed > 0) && empty($product.gift) && !$noDeleteButton}
        <div>
          <a rel="nofollow" title="{l s='Delete'}" class="cart_quantity_delete" id="{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "delete=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")|escape:'html':'UTF-8'}">{l s='Remove from Cart'}</a>
        </div>
      {else}
        <div style="width: 100%; height: 1px"></div>
      {/if}
  </div>
</div>

{*
<tr id="product_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}" class="cart_item address_{$product.id_address_delivery|intval} {if $odd}odd{else}even{/if} textlink-nostyle no-border">
  <td class="cart_product no-border">
    <a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop, $product.id_product_attribute, false, false, true)|escape:'html':'UTF-8'}">
        <img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'small', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
             alt="{$product.name|escape:'html':'UTF-8'}"
             width="{getWidthSize|intval type='small'}"
             height="{getHeightSize|intval type='small'}"
             loading="lazy"
        >
    </a>
  </td>

  <td class="cart_description no-border">
    {capture name=sep} : {/capture}
    {capture}{l s=' : '}{/capture}
    <p class="product-name textlink-nostyle"><a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop, $product.id_product_attribute, false, false, true)|escape:'html':'UTF-8'}" class="textlink-nostyle">{$product.name|escape:'html':'UTF-8'}</a></p>
    {if $product.reference}<small class="cart_ref">{l s='SKU'}{$smarty.capture.default}{$product.reference|escape:'html':'UTF-8'}</small>{/if}
    {if isset($product.attributes) && $product.attributes}<small><a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop, $product.id_product_attribute, false, false, true)|escape:'html':'UTF-8'}">{$product.attributes|@replace: $smarty.capture.sep:$smarty.capture.default|escape:'html':'UTF-8'}</a></small>{/if}
  </td>

  {if $PS_STOCK_MANAGEMENT}
    <td class="cart_avail no-border">
      <span class="label{if $product.quantity_available <= 0 && (isset($product.allow_oosp) && !$product.allow_oosp)} label-danger{else if $product.quantity_available <= 0 && (isset($product.allow_oosp) && $product.allow_oosp)} label-warning{else} label-success{/if}">
        {if $product.quantity_available <= 0}
          {if isset($product.allow_oosp) && $product.allow_oosp}
            {$orderLaterLabel}
          {else}
            {l s='Out of Stock'}
          {/if}
        {else}
          {$orderNowLabel}
        {/if}
      </span>
      {if !$product.is_virtual}{hook h="displayProductDeliveryTime" product=$product}{/if}
    </td>
  {/if}

  <!-- Price -->
  <td class="cart_unit no-border" data-title="{l s='Unit price'}">
    <ul class="price text-{if $isRtl}left{else}right{/if}" id="product_price_{$product.id_product}_{$product.id_product_attribute}{if $quantityDisplayed > 0}_nocustom{/if}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}">
      {if !empty($product.gift)}
        <li class="gift-icon">{l s='Gift!'}</li>
      {else}
        {if isset($product.is_discounted) && $product.is_discounted && isset($product.reduction_applies) && $product.reduction_applies}
          <li class="old-price">{convertPrice price=$product.price_without_specific_price}</li>

          <li class="price-percent-reduction small">
            {if !$priceDisplay}
              {if isset($product.reduction_type) && $product.reduction_type == 'amount'}
                {assign var='priceReduction' value=($product.price_wt - $product.price_without_specific_price)}
                {assign var='symbol' value=$currency->sign}
              {else}
                {assign var='priceReduction' value=(($product.price_without_specific_price - $product.price_wt)/$product.price_without_specific_price) * 100 * -1}
                {assign var='symbol' value='%'}
              {/if}
            {else}
              {if isset($product.reduction_type) && $product.reduction_type == 'amount'}
                {assign var='priceReduction' value=($product.price - $product.price_without_specific_price)}
                {assign var='symbol' value=$currency->sign}
              {else}
                {assign var='priceReduction' value=(($product.price_without_specific_price - $product.price)/$product.price_without_specific_price) * -100}
                {assign var='symbol' value='%'}
              {/if}
            {/if}
            {if $symbol == '%'}
              &nbsp;{$priceReduction|string_format:"%.2f"|regex_replace:"/[^\d]0+$/":""}{$symbol}&nbsp;
            {else}
              &nbsp;{convertPrice price=$priceReduction}&nbsp;
            {/if}
          </li>
        {/if}

        {if !$priceDisplay}
          <li class="price final-price small{if isset($product.is_discounted) && $product.is_discounted && isset($product.reduction_applies) && $product.reduction_applies} special-price{/if}">{convertPrice price=$product.price_wt}</li>
        {else}
          <li class="price final-price small{if isset($product.is_discounted) && $product.is_discounted && isset($product.reduction_applies) && $product.reduction_applies} special-price{/if}">{convertPrice price=$product.price}</li>
        {/if}
      {/if}
    </ul>
  </td>

  <td class="cart_quantity text-center no-border" data-title="{l s='Quantity'}">
    {if (isset($cannotModify) && $cannotModify == 1)}
      <span>
        {if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}
          {$product.customizationQuantityTotal}
        {else}
          {$product.cart_quantity-$quantityDisplayed}
        {/if}
      </span>
    {else}
      {if isset($customizedDatas.$productId.$productAttributeId) AND $quantityDisplayed == 0}
        <span id="cart_quantity_custom_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval}" >{$product.customizationQuantityTotal}</span>
      {/if}
      {if !isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed > 0}
        <input type="hidden" value="{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}" name="quantity_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}_hidden">
        <input size="2" type="text" autocomplete="off" class="cart_quantity_input form-control text-center" style="font-size: 1.5em; outline: none; border: none" value="{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}"  name="quantity_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}">

        <div class="cart_quantity_button clearfix">
          {if $product.minimal_quantity < ($product.cart_quantity-$quantityDisplayed) OR $product.minimal_quantity <= 1}
            <a rel="nofollow" class="cart_quantity_down btn btn-default button-minus" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;op=down&amp;token={$token_cart}")|escape:'html':'UTF-8'}" title="{l s='Subtract'}">
              <i class="icon icon-fw icon-minus"></i>
            </a>
          {else}
            <a class="cart_quantity_down btn btn-default button-minus disabled" href="#" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" title="{l s='You must purchase a minimum of %d of this product.' sprintf=$product.minimal_quantity}">
              <i class="icon icon-fw icon-minus"></i>
            </a>
          {/if}
          <a rel="nofollow" class="cart_quantity_up btn btn-default button-plus" id="cart_quantity_up_{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")|escape:'html':'UTF-8'}" title="{l s='Add'}"><i class="icon icon-fw icon-plus"></i></a>
        </div>
      {/if}
    {/if}
  </td>

  {if !isset($noDeleteButton) || !$noDeleteButton}
    <td class="cart_delete text-center no-border" data-title="{l s='Delete'}">
      {if (!isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed > 0) && empty($product.gift)}
        <div>
          <a rel="nofollow" title="{l s='Delete'}" class="cart_quantity_delete" id="{$product.id_product}_{$product.id_product_attribute}_{if $quantityDisplayed > 0}nocustom{else}0{/if}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "delete=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")|escape:'html':'UTF-8'}"><i class="icon icon-trash"></i></a>
        </div>
      {else}

      {/if}
    </td>
  {/if}

  <td class="cart_total no-border" data-title="{l s='Total'}">
    <span class="price total-price" id="total_product_price_{$product.id_product}_{$product.id_product_attribute}{if $quantityDisplayed > 0}_nocustom{/if}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}">
      {if !empty($product.gift)}
        <span class="gift-icon">{l s='Gift!'}</span>
      {else}
        {if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}
          {if !$priceDisplay}{displayPrice price=$product.total_customization_wt}{else}{displayPrice price=$product.total_customization}{/if}
        {else}
          {if !$priceDisplay}{displayPrice price=$product.total_wt}{else}{displayPrice price=$product.total}{/if}
        {/if}
      {/if}
    </span>
  </td>

</tr>
*}