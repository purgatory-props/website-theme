{include file="$tpl_dir./errors.tpl"}

{if !$priceDisplay || $priceDisplay == 2}
    {assign var='productPrice' value=$product->getPrice(true)}
    {assign var='productPriceWithoutReduction' value=$product->getPriceWithoutReduct(false)}
{elseif $priceDisplay == 1}
    {assign var='productPrice' value=$product->getPrice(false)}
    {assign var='productPriceWithoutReduction' value=$product->getPriceWithoutReduct(true)}
{/if}
{assign var='cartDefaultWidth' value={getWidthSize|intval type='cart'}}
{assign var='cartDefaultHeight' value={getHeightSize|intval type='cart'}}
{assign var='largeDefaultWidth' value={getWidthSize|intval type='large'}}
{assign var='largeDefaultHeight' value={getHeightSize|intval type='large'}}

<div class="product-wrapper" itemscope itemtype="https://schema.org/Product">
    <meta itemprop="url" content="{$link->getProductLink($product)|escape:'htmlall':'UTF-8'}">

    <div class="product-header">
        {if !empty($confirmation)}
            <div class="alert alert-warning">{$confirmation}</div>
        {/if}

        <div class="product-header-left">
            <div class="product-image-block clearfix">
                <!-- Labels -->
                <div class="product-labels">
                    {if (!$PS_CATALOG_MODE AND ((isset($product->show_price) && $product->show_price) || (isset($product->available_for_order) && $product->available_for_order)))}
                        {if isset($product->online_only) && $product->online_only}
                            <span class="product-label product-label-online">{l s='Online only'}</span>
                        {/if}
                    {/if}
                    {if isset($product->coming_soon) && $product->coming_soon == 1}
                        <span class="product-label product-label-comingsoon">Coming Soon!</span>
                    {/if}
                    {if isset($product->new) && $product->new == 1}
                        <span class="product-label product-label-new">{l s='New'}</span>
                    {/if}
                    {if isset($product->on_sale) && $product->on_sale && isset($product->show_price) && $product->show_price && !$PS_CATALOG_MODE}
                        <span class="product-label product-label-sale">{l s='Sale!'}</span>
                    {elseif isset($product->reduction) && $product->reduction && isset($product->show_price) && $product->show_price && !$PS_CATALOG_MODE}
                        <span class="product-label product-label-discount">{l s='Reduced price!'}</span>
                    {/if}
                </div>

                {if $have_image}
                    <a class="fancybox" data-fancybox-group="product" id="view_full_size" href="{$link->getProductLink($product)|escape:'html':'UTF-8'}" onclick="return false;">
                         <picture id="bigpic">
                            <!--[if IE 9]><video style="display: none;"><![endif]-->
                            {if !empty($webp)}
                                <source class="img-responsive center-block product-image"
                                    itemprop="image"
                                    src="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'large', 'webp', ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
                                    title="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}"
                                    type="image/webp"
                                >
                            {/if}
                            <!--[if IE 9]></video><![endif]-->
                            <img class="img-responsive center-block product-image"
                                itemprop="image"
                                src="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'large', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
                                title="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}"
                                alt="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}"
                                width="{$largeDefaultWidth|intval}"
                                height="{$largeDefaultHeight|intval}"
                            >
                        </picture>
                    </a>
                {else}
                    Uhhhh...
                {/if}
            </div>

            <!-- TODO: List of images -->
        </div>

        <div class="product-header-right">
            <h1 itemprop="name" class="spooky-font no-margin">{$product->name|escape:'html':'UTF-8'}</h1>
            <p class="sku" {if empty($product->reference) || !$product->reference} style="display: none;"{/if}>
                <meta itemprop="sku"{if !empty($product->reference) && $product->reference} content="{$product->reference}"{/if}>
                <span>{$product->reference|escape:'html':'UTF-8'}</span>
            </p>

            {if $product->description_short}
                <div id="short_description_block">
                    <div id="short_description_content" class="rte" itemprop="description">{$product->description_short}</div>
                </div>
            {/if}

            <div id="oosHook"{if $product->quantity > 0} style="display: none;"{/if}>
                {$HOOK_PRODUCT_OOS}
            </div>


            <div class="product-flags">
                {assign var=isService value=false}

                {foreach from=$product->ui_tags item=t}
                    {if $product->show_price || (($t['key'] == '--discontinued') || ($t['key'] == '--service'))}
                        <div class="ui-tag ui-tag-{$t['name']}" style="background-color: {$t['bgcolor']}; color: {$t['fgcolor']}">
                            <span class="ui-tag-title">{$t['title']}</span>
                            <div class="ui-tag-desc">{$t['body']}</div>
                        </div>
                    {/if}
                {/foreach}
            </div>

            <div class="product-actions">
                 {if $product->is_service}
                    <!-- Service Starting Price and Contact Button -->
                    <div class="service-price-container" itemprop="offers" itemscope itemtype="https://schema.org/Offer">
                        {l s='Starting at'} <span id="our_price_display" class="price service-price accent-color">{convertPrice price=$productPrice|floatval}</span>
                        <meta itemprop="price" content="{$productPrice}">
                    </div>

                    <div class="service-contact-container">
                        <a href="{$link->getPageLink('contact', true)|escape:'html':'UTF-8'}?sendTo=4">
                            <button class="service-contact-btn">
                                {l s='Contact Us About This Service'}
                            </button>
                        </a>
                    </div>
                {else}
                    <!-- Add to Cart Button and Quantity if Available -->
                    {if ($product->show_price && !isset($restricted_country_mode)) || isset($groups) || $product->reference || (isset($HOOK_PRODUCT_ACTIONS) && $HOOK_PRODUCT_ACTIONS)}
                        <form id="buy_block"{if $PS_CATALOG_MODE && !isset($groups) && $product->quantity > 0} class="hidden"{/if} action="{$link->getPageLink('cart')|escape:'html':'UTF-8'}" method="post">

                            <input type="hidden" name="token" value="{$static_token}">
                            <input type="hidden" name="id_product" value="{$product->id|intval}" id="product_page_product_id">
                            <input type="hidden" name="add" value="1">
                            <input type="hidden" name="id_product_attribute" id="idCombination" value="">

                            <div class="box-info-product">
                                <div class="content_prices clearfix">
                                    {if $product->show_price && !isset($restricted_country_mode) && !$PS_CATALOG_MODE}
                                    <div>
                                        <p class="our_price_display accent-color" itemprop="offers" itemscope itemtype="https://schema.org/Offer">{strip}
                                            {if $product->quantity > 0}<link itemprop="availability" href="https://schema.org/InStock">{/if}
                                            {if $priceDisplay >= 0 && $priceDisplay <= 2}
                                            <meta itemprop="price" content="{$productPrice}">
                                            <span id="our_price_display" class="price">{convertPrice price=$productPrice|floatval}</span>
                                            {if $tax_enabled  && ((isset($display_tax_label) && $display_tax_label == 1) || !isset($display_tax_label))}
                                                {if $priceDisplay == 1} {l s='tax excl.'}{else} {l s='tax incl.'}{/if}
                                            {/if}
                                            <meta itemprop="priceCurrency" content="{$currency->iso_code}">
                                            {hook h="displayProductPriceBlock" product=$product type="price"}
                                            {/if}
                                        {/strip}</p>
                                        <p id="reduction_percent" {if $productPriceWithoutReduction <= 0 || !$product->specificPrice || $product->specificPrice.reduction_type != 'percentage'} style="display:none;"{/if}>{strip}
                                            <span id="reduction_percent_display">
                                            {if $product->specificPrice && $product->specificPrice.reduction_type == 'percentage'}-{$product->specificPrice.reduction*100}%{/if}
                                            </span>
                                        {/strip}</p>
                                        <p id="reduction_amount" {if $productPriceWithoutReduction <= 0 || !$product->specificPrice || $product->specificPrice.reduction_type != 'amount' || $product->specificPrice.reduction|floatval ==0} style="display:none"{/if}>{strip}
                                            <span id="reduction_amount_display">
                                            {if $product->specificPrice && $product->specificPrice.reduction_type == 'amount' && $product->specificPrice.reduction|floatval !=0}
                                                -{convertPrice price=$productPriceWithoutReduction|floatval-$productPrice|floatval}
                                            {/if}
                                            </span>
                                        {/strip}</p>
                                        <p id="old_price"{if (!$product->specificPrice || !$product->specificPrice.reduction)} class="hidden"{/if}>{strip}
                                            {if $priceDisplay >= 0 && $priceDisplay <= 2}
                                            {hook h="displayProductPriceBlock" product=$product type="old_price"}
                                            <span id="old_price_display"><span class="price">{if $productPriceWithoutReduction > $productPrice}{convertPrice price=$productPriceWithoutReduction|floatval}{/if}</span>{if $productPriceWithoutReduction > $productPrice && $tax_enabled && $display_tax_label == 1} {if $priceDisplay == 1}{l s='tax excl.'}{else}{l s='tax incl.'}{/if}{/if}</span>
                                            {/if}
                                        {/strip}</p>
                                        {if $priceDisplay == 2}
                                        <br>
                                        <span id="pretaxe_price">{strip}
                                            <span id="pretaxe_price_display">{convertPrice price=$product->getPrice(false)}</span> {l s='tax excl.'}
                                        {/strip}</span>
                                        {/if}
                                    </div>
                                    {if $packItems|@count && $productPrice < $product->getNoPackPrice()}
                                        <p class="pack_price">{l s='Instead of'} <span style="text-decoration: line-through;">{convertPrice price=$product->getNoPackPrice()}</span></p>
                                    {/if}
                                    {if $product->ecotax != 0}
                                        <p class="price-ecotax">{l s='Including'} <span id="ecotax_price_display">{if $priceDisplay == 2}{$ecotax_tax_exc|convertAndFormatPrice}{else}{$ecotax_tax_inc|convertAndFormatPrice}{/if}</span> {l s='for ecotax'}
                                        {if $product->specificPrice && $product->specificPrice.reduction}
                                            <br>{l s='(not impacted by the discount)'}
                                        {/if}
                                        </p>
                                    {/if}
                                    {if !empty($product->unity) && $product->unit_price_ratio > 0.000000}
                                        {math equation="pprice / punit_price" pprice=$productPrice  punit_price=$product->unit_price_ratio assign=unit_price}
                                        <p class="unit-price"><span id="unit_price_display">{convertPrice price=$unit_price}</span> {l s='per'} {$product->unity|escape:'html':'UTF-8'}</p>
                                        {hook h="displayProductPriceBlock" product=$product type="unit_price"}
                                    {/if}
                                    {/if} {*close if for show price*}
                                    {hook h="displayProductPriceBlock" product=$product type="weight" hook_origin='product_sheet'}
                                    {hook h="displayProductPriceBlock" product=$product type="after_price"}
                                </div>

                                <div class="product_attributes clearfix">
                                    <p id="minimal_quantity_wanted_p"{if $product->minimal_quantity <= 1 || !$product->available_for_order || $PS_CATALOG_MODE} style="display: none;"{/if}>
                                        {l s='The minimum purchase order quantity for the product is'} <b id="minimal_quantity_label">{$product->minimal_quantity}</b>
                                    </p>

                                    {if isset($groups)}
                                    <div id="attributes">
                                        {foreach from=$groups key=id_attribute_group item=group}
                                        {if !empty($group.attributes)}
                                            <fieldset class="attribute_fieldset form-group">
                                            <label class="attribute_label" {if $group.group_type != 'color' && $group.group_type != 'radio'}for="group_{$id_attribute_group|intval}"{/if}>{$group.name|escape:'html':'UTF-8'}&nbsp;</label>
                                            {assign var="groupName" value="group_$id_attribute_group"}
                                            <div class="attribute_list">
                                                {if ($group.group_type == 'select')}
                                                <select name="{$groupName}" id="group_{$id_attribute_group|intval}" class="form-control attribute_select no-print">
                                                    {foreach from=$group.attributes key=id_attribute item=group_attribute}
                                                    <option value="{$id_attribute|intval}"{if (isset($smarty.get.$groupName) && $smarty.get.$groupName|intval == $id_attribute) || $group.default == $id_attribute} selected="selected"{/if} title="{$group_attribute|escape:'html':'UTF-8'}">{$group_attribute|escape:'html':'UTF-8'}</option>
                                                    {/foreach}
                                                </select>
                                                {elseif ($group.group_type == 'color')}
                                                <ul id="color_to_pick_list">
                                                    {assign var="default_colorpicker" value=""}
                                                    {foreach from=$group.attributes key=id_attribute item=group_attribute}
                                                    {assign var='img_color_exists' value=file_exists($col_img_dir|cat:$id_attribute|cat:'.jpg')}
                                                    <li{if $group.default == $id_attribute} class="selected"{/if}>
                                                        <a href="{$link->getProductLink($product)|escape:'html':'UTF-8'}" id="color_{$id_attribute|intval}" class="color_pick{if ($group.default == $id_attribute)} selected{/if}"{if !$img_color_exists && isset($colors.$id_attribute.value) && $colors.$id_attribute.value} style="background:{$colors.$id_attribute.value|escape:'html':'UTF-8'};"{/if} title="{$colors.$id_attribute.name|escape:'html':'UTF-8'}">
                                                        {if $img_color_exists}
                                                            <img src="{$img_col_dir}{$id_attribute|intval}.jpg" alt="{$colors.$id_attribute.name|escape:'html':'UTF-8'}" title="{$colors.$id_attribute.name|escape:'html':'UTF-8'}" width="20" height="20">
                                                        {/if}
                                                        </a>
                                                    </li>
                                                    {if ($group.default == $id_attribute)}
                                                        {$default_colorpicker = $id_attribute}
                                                    {/if}
                                                    {/foreach}
                                                </ul>
                                                <input type="hidden" class="color_pick_hidden" name="{$groupName|escape:'html':'UTF-8'}" value="{$default_colorpicker|intval}">
                                                {elseif ($group.group_type == 'radio')}
                                                <ul>
                                                    {foreach from=$group.attributes key=id_attribute item=group_attribute}
                                                    <li>
                                                        <input type="radio" class="attribute_radio" name="{$groupName|escape:'html':'UTF-8'}" value="{$id_attribute}" {if ($group.default == $id_attribute)} checked="checked"{/if}>
                                                        <span class="label-text">{$group_attribute|escape:'html':'UTF-8'}</span>
                                                    </li>
                                                    {/foreach}
                                                </ul>
                                                {/if}
                                            </div>
                                            </fieldset>
                                        {/if}
                                        {/foreach}
                                    </div>
                                    {/if}
                                </div>

                                <div class="box-cart-bottom">
                                    {if !$PS_CATALOG_MODE}
                                    <div id="quantity_wanted_p"{if (!$allow_oosp && $product->quantity <= 0) || !$product->available_for_order || $PS_CATALOG_MODE} style="display: none;"{/if}>
                                        <div><label for="quantity_wanted">{l s='Quantity'}</label></div>
                                        <div class="input-group quantity-input" style="margin-top: 5px;">
                                            <input type="number" min="1" name="qty" id="quantity_wanted" class="text-center quantity-input" id="quantity_wanted"  value="{if isset($quantityBackup)}{$quantityBackup|intval}{else}{if $product->minimal_quantity > 1}{$product->minimal_quantity}{else}1{/if}{/if}">
                                        </div>
                                    </div>
                                    {/if}

                                    {if $product->available_for_order}
                                    <div {if (!$allow_oosp && $product->quantity <= 0) || !$product->available_for_order || (isset($restricted_country_mode) && $restricted_country_mode) || $PS_CATALOG_MODE} class="unvisible"{/if}>
                                        <p id="add_to_cart" class="buttons_bottom_block no-print">
                                            <button type="submit" name="Submit" class="btn btn-block btn-lg btn-success btn-add-to-cart">
                                            <i class="icon icon-shopping-basket"></i>
                                            <span>{if $content_only && (isset($product->customization_required) && $product->customization_required)}{l s='Customize'}{else}{l s='Add to Cart'}{/if}</span>
                                            </button>
                                        </p>
                                    </div>
                                    {/if}
                                </div>
                            </div>
                        </form>
                        {/if}
                        {if isset($HOOK_EXTRA_RIGHT) && $HOOK_EXTRA_RIGHT}{$HOOK_EXTRA_RIGHT}{/if}

                {/if}
            </div>
        </div>
    </div>


    <div class="clearfix"></div>
</div>