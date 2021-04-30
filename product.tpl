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

{assign var='mediumDefaultWidth' value={getWidthSize|intval type='home'}}
{assign var='mediumDefaultHeight' value={getHeightSize|intval type='home'}}

{assign var='largeDefaultWidth' value={getWidthSize|intval type='large'}}
{assign var='largeDefaultHeight' value={getHeightSize|intval type='large'}}

{assign var='isActuallyOnSale' value=false}
{if $product->base_price > $productPrice}
    {assign var='isActuallyOnSale' value=true}
{/if}

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
                        <span class="product-label product-label-discount">{l s='Reduced Price!'}</span>
                    {/if}
                </div>

                {if $have_image}
                    <a href="{$link->getImageLink($product->link_rewrite, $cover.id_image, '', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
                        id="fullImageLink"
                        class="fullImageLink"
                        target="_blank"
                        title="{l s='View Full Image'}"
                    >
                            <div class="magnify-image">
                                <div class="magnify-image-container center" style="width: {$largeDefaultWidth|intval}px; height: {$largeDefaultHeight|intval}px">
                                    <i class="fa fa-search center"></i>
                                </div>
                            </div>

                            <!--[if IE 9]></video><![endif]-->
                            <img class="img-responsive center-block product-image center"
                                itemprop="image"
                                src="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'large', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
                                title="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}"
                                alt="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}"
                                width="{$largeDefaultWidth|intval}"
                                height="{$largeDefaultWidth|intval}"
                                id="productImage"
                            >
                    </a>

                {else}
                    Uhhhh...
                {/if}
            </div>

            {* Other Images *}
            <div class="images-list clearfix{if isset($images) && count($images) < 2} hidden{/if}">
                <div class="thumbnail_list">
                    <ul class="list-unstyled">
                        {if isset($images)}
                            {foreach from=$images item=image name=thumbnails}
                                {assign var=imageIds value="`$product->id`-`$image.id_image`"}
                                {if !empty($image.legend)}
                                    {assign var=imageTitle value=$image.legend|escape:'html':'UTF-8'}
                                {else}
                                    {assign var=imageTitle value=$product->name|escape:'html':'UTF-8'}
                                {/if}

                                {assign var=imageURL value=$link->getImageLink($product->link_rewrite, $imageIds, 'large', null, ImageManager::retinaSupport())}
                                {assign var=imageFullURL value=$link->getImageLink($product->link_rewrite, $imageIds, '', null, ImageManager::retinaSupport())}

                                <li data-slide-num="{$smarty.foreach.thumbnails.iteration|intval}" id="thumbnail_{$image.id_image|intval}" style="display: inline-block">
                                    <a data-image="{$imageURL}"
                                        data-fullImage="{$imageFullURL}"
                                        class="thumbnail thumbnail-link fancybox{if $image.id_image == $cover.id_image} shown{/if}"
                                        title="{$imageTitle|escape:'htmlall':'UTF-8'}"
                                        onclick="changeBigPictureForProduct(event); return false;"
                                    >
                                        <img src="{$link->getImageLink($product->link_rewrite, $imageIds, 'cart', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
                                            data-image="{$imageURL}"
                                            data-fullImage="{$imageFullURL}"
                                            alt="{$imageTitle}"
                                            title="{$imageTitle}"
                                            itemprop="image"
                                            width="{$cartDefaultWidth|intval}"
                                            height="{$cartDefaultHeight|intval}"
                                            onclick="return false;"
                                        >
                                    </a>

                                    <img src="{$imageURL}" class="image-preload" > {* Preload full image so it loads fast when selected *}
                                </li>
                            {/foreach}
                        {/if}
                    </ul>
                </div>
            </div>

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

                        {if $t['key'] == '--service'}
                            {assign var=isService value=true}
                        {/if}
                    {/if}
                {/foreach}
            </div>

            <!-- Add To Cart and Stuff -->
            <div class="product-actions">
                {if $isService}
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
                                                <span id="our_price_display" class="price">
                                                    {if $isActuallyOnSale}
                                                        <span class="old-price">{convertPrice price=$product->base_price|floatval}</span>
                                                    {/if}
                                                    {convertPrice price=$productPrice|floatval}
                                                </span>
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

    {if !$content_only}
        <div class="product-tabs">
            {if isset($product) && $product->description}
                {assign var=tabID value="tab-description"}
                <input name="product-tabs" type="radio" id="{$tabID}" checked="checked" class="tab-switch" autocomplete="off"/>
                <label for="{$tabID}" class="tab-label noselect">{l s='Details'}</label>

                <div class="product-tab description-tab">
                    {$product->description}
                </div>
            {/if}

            {if isset($features) && $features}
                {assign var=tabID value="tab-specs"}
                <input name="product-tabs" type="radio" id="{$tabID}" class="tab-switch" autocomplete="off"/>
                <label for="{$tabID}" class="tab-label noselect">{l s='Specs'}</label>

                <div class="product-tab specs-tab">
                    <table class="table-data-sheet">
                        {foreach from=$features item=feature}
                            <tr class="{cycle values="odd,even"}">
                                {if isset($feature.value)}
                                    <td class="row-label" style="font-weight: bold; padding: 5.5px 30px 10px 0">{$feature.name|escape:'html':'UTF-8'}</td>
                                    <td class="row-data">{$feature.value|escape:'html':'UTF-8'}</td>
                                {/if}
                            </tr>
                        {/foreach}
                    </table>
                </div>
            {/if}

            {if isset($attachments) && $attachments}
                {assign var=tabID value="tab-downloads"}
                <input name="product-tabs" type="radio" id="{$tabID}" class="tab-switch" autocomplete="off"/>
                <label for="{$tabID}" class="tab-label noselect">{l s='Downloads'}</label>

                <div class="product-tab downloads-tab">
                    {foreach from=$attachments item=attachment name=attachment}
                        <a href="{$link->getPageLink('attachment', true, NULL, "id_attachment={$attachment.id_attachment}")|escape:'html':'UTF-8'}" class="attachment-link" target="_blank" title="{$attachment.name}">
                            <i class="fa fa-download"></i> {$attachment.name} <span class="attachment-size">({Tools::formatBytes($attachment.file_size, 2)})</span>
                        </a>
                    {/foreach}
                </div>
            {/if}

            {if isset($accessories) && $accessories}
                {assign var=tabID value="tab-accessories"}
                <input name="product-tabs" type="radio" id="{$tabID}" class="tab-switch" autocomplete="off"/>
                <label for="{$tabID}" class="tab-label noselect">{l s='Accessories'}</label>

                <div class="product-tab accessories-tab">
                    {include file="$tpl_dir./product-list.tpl" products=$accessories}
                </div>
            {/if}
        </div>
    {/if}

    {strip}
    {if isset($smarty.get.ad) && $smarty.get.ad}
      {addJsDefL name=ad}{$base_dir|cat:$smarty.get.ad|escape:'html':'UTF-8'}{/addJsDefL}
    {/if}
    {if isset($smarty.get.adtoken) && $smarty.get.adtoken}
      {addJsDefL name=adtoken}{$smarty.get.adtoken|escape:'html':'UTF-8'}{/addJsDefL}
    {/if}
    {addJsDef allowBuyWhenOutOfStock=$allow_oosp|boolval}
    {addJsDef availableNowValue=$product->available_now|escape:'quotes':'UTF-8'}
    {addJsDef availableLaterValue=$product->available_later|escape:'quotes':'UTF-8'}
    {addJsDef attribute_anchor_separator=$attribute_anchor_separator|escape:'quotes':'UTF-8'}
    {addJsDef attributesCombinations=$attributesCombinations}
    {addJsDef currentDate=$smarty.now|date_format:'%Y-%m-%d %H:%M:%S'}
    {if isset($combinations) && $combinations}
      {addJsDef combinations=$combinations}
      {addJsDef combinationsFromController=$combinations}
      {addJsDef displayDiscountPrice=$display_discount_price}
      {addJsDefL name='upToTxt'}{l s='Up to' js=1}{/addJsDefL}
    {/if}
    {if isset($combinationImages) && $combinationImages}
      {addJsDef combinationImages=$combinationImages}
    {/if}
    {addJsDef customizationId=$id_customization}
    {addJsDef customizationFields=$customizationFields}
    {addJsDef default_eco_tax=$product->ecotax|floatval}
    {addJsDef displayPrice=$priceDisplay|intval}
    {addJsDef ecotaxTax_rate=$ecotaxTax_rate|floatval}
    {if isset($cover.id_image_only)}
      {addJsDef idDefaultImage=$cover.id_image_only|intval}
    {else}
      {addJsDef idDefaultImage=0}
    {/if}
    {addJsDef img_ps_dir=$img_ps_dir}
    {addJsDef img_prod_dir=$img_prod_dir}
    {addJsDef id_product=$product->id|intval}
    {addJsDef jqZoomEnabled=$jqZoomEnabled|boolval}
    {addJsDef maxQuantityToAllowDisplayOfLastQuantityMessage=$last_qties|intval}
    {addJsDef minimalQuantity=$product->minimal_quantity|intval}
    {addJsDef noTaxForThisProduct=$no_tax|boolval}
    {if isset($customer_group_without_tax)}
      {addJsDef customerGroupWithoutTax=$customer_group_without_tax|boolval}
    {else}
      {addJsDef customerGroupWithoutTax=false}
    {/if}
    {if isset($group_reduction)}
      {addJsDef groupReduction=$group_reduction|floatval}
    {else}
      {addJsDef groupReduction=false}
    {/if}
    {addJsDef oosHookJsCodeFunctions=Array()}
    {addJsDef productHasAttributes=isset($groups)|boolval}
    {addJsDef productPriceTaxExcluded=($product->getPriceWithoutReduct(true)|default:'null' - $product->ecotax)|floatval}
    {addJsDef productPriceTaxIncluded=($product->getPriceWithoutReduct(false)|default:'null' - $product->ecotax * (1 + $ecotaxTax_rate / 100))|floatval}
    {addJsDef productBasePriceTaxExcluded=($product->getPrice(false, null, $smarty.const._TB_PRICE_DATABASE_PRECISION_, null, false, false) - $product->ecotax)|floatval}
    {addJsDef productBasePriceTaxExcl=($product->getPrice(false, null, $smarty.const._TB_PRICE_DATABASE_PRECISION_, null, false, false)|floatval)}
    {addJsDef productBasePriceTaxIncl=($product->getPrice(true, null, $smarty.const._TB_PRICE_DATABASE_PRECISION_, null, false, false)|floatval)}
    {addJsDef productReference=$product->reference|escape:'html':'UTF-8'}
    {addJsDef productAvailableForOrder=$product->available_for_order|boolval}
    {addJsDef productComingSoon=$product->coming_soon|boolval}
    {addJsDef productPriceWithoutReduction=$productPriceWithoutReduction|floatval}
    {addJsDef productPrice=$productPrice|floatval}
    {addJsDef productUnitPriceRatio=$product->unit_price_ratio|floatval}
    {addJsDef productShowPrice=(!$PS_CATALOG_MODE && $product->show_price)|boolval}
    {addJsDef PS_CATALOG_MODE=$PS_CATALOG_MODE}
    {if $product->specificPrice && $product->specificPrice|@count}
      {addJsDef product_specific_price=$product->specificPrice}
    {else}
      {addJsDef product_specific_price=array()}
    {/if}
    {if $display_qties == 1 && $product->quantity}
      {addJsDef quantityAvailable=$product->quantity}
    {else}
      {addJsDef quantityAvailable=0}
    {/if}
    {addJsDef quantitiesDisplayAllowed=$display_qties|boolval}
    {if $product->specificPrice && $product->specificPrice.reduction && $product->specificPrice.reduction_type == 'percentage'}
      {addJsDef reduction_percent=$product->specificPrice.reduction*100|floatval}
    {else}
      {addJsDef reduction_percent=0}
    {/if}
    {if $product->specificPrice && $product->specificPrice.reduction && $product->specificPrice.reduction_type == 'amount'}
      {addJsDef reduction_price=$product->specificPrice.reduction|floatval}
    {else}
      {addJsDef reduction_price=0}
    {/if}
    {if $product->specificPrice && $product->specificPrice.price}
      {addJsDef specific_price=$product->specificPrice.price|floatval}
    {else}
      {addJsDef specific_price=0}
    {/if}
    {addJsDef specific_currency=($product->specificPrice && $product->specificPrice.id_currency)|boolval} {* TODO: remove if always false *}
    {addJsDef stock_management=$PS_STOCK_MANAGEMENT|intval}
    {addJsDef taxRate=$tax_rate|floatval}
    {addJsDefL name=doesntExist}{l s='This combination does not exist for this product. Please select another combination.' js=1}{/addJsDefL}
    {addJsDefL name=doesntExistNoMore}{l s='This product is no longer in stock' js=1}{/addJsDefL}
    {addJsDefL name=doesntExistNoMoreBut}{l s='with those attributes but is available with others.' js=1}{/addJsDefL}
    {addJsDefL name=fieldRequired}{l s='Please fill in all the required fields before saving your customization.' js=1}{/addJsDefL}
    {addJsDefL name=uploading_in_progress}{l s='Uploading in progress, please be patient.' js=1}{/addJsDefL}
    {addJsDefL name='product_fileDefaultHtml'}{l s='No file selected' js=1}{/addJsDefL}
    {addJsDefL name='product_fileButtonHtml'}{l s='Choose File' js=1}{/addJsDefL}
  {/strip}
</div>