{capture name="newProduct"}{hook h='actionModifyProductForExtraFunctionality' product=$product capture=true}{/capture}
{assign var="product" value=unserialize($smarty.capture.newProduct)}

<a class="grid-item-wrapper" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'} - {$product.description_short|strip_tags:'UTF-8'|truncate:40:'...'}" itemprop="url">
    <div class="product-container" itemscope itemtype="https://schema.org/Product">
            <img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'home', null, ImageManager::retinaSupport())|escape:'html':'UTF-8'}"
                itemprop="image"
                width="{getWidthSize|intval type='home'}"
                height="{getHeightSize|intval type='home'}"
                loading="lazy"
                />

        <div class="product-title">
            <h3 itemprop="name">{$product.name}</h3>
        </div>

        <div class="product-price">
            {if isset($product.show_price) && $product.show_price && !isset($restricted_country_mode) && (isset($product.is_service) && !$product.is_service)}
                <span class="price">{if !$priceDisplay}{convertPrice price=$product.price}{else}{convertPrice price=$product.price_tax_exc}{/if}</span>
            {/if}
        </div>

        <div class="product-description" itemprop="description">
            {$product.description_short|strip_tags:'UTF-8'|truncate:360:'...'}
        </div>

        <div class="product-labels">
            {if (!$PS_CATALOG_MODE AND ((isset($product.show_price) && $product.show_price) || (isset($product.available_for_order) && $product.available_for_order)))}
                {if isset($product.online_only) && $product.online_only}
                    <span class="product-label product-label-online">{l s='Online only'}</span>
                {/if}
            {/if}
            {if isset($product.coming_soon) && $product.coming_soon == 1}
                <span class="product-label product-label-comingsoon">{l s='Coming Soon!'}</span>
            {/if}
            {if isset($product.new) && $product.new == 1}
                <span class="product-label product-label-new">{l s='New'}</span>
            {/if}
            {if isset($product.on_sale) && $product.on_sale && isset($product.show_price) && $product.show_price && !$PS_CATALOG_MODE}
                <span class="product-label product-label-sale">{l s='Sale!'}</span>
            {elseif isset($product.reduction) && $product.reduction && isset($product.show_price) && $product.show_price && !$PS_CATALOG_MODE}
                <span class="product-label product-label-discount">{l s='Reduced Price!'}</span>
            {/if}
        </div>
    </div>
</a>
