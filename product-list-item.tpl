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
            {if isset($product.show_price) && $product.show_price && !isset($restricted_country_mode)}
                <span class="price">{if !$priceDisplay}{convertPrice price=$product.price}{else}{convertPrice price=$product.price_tax_exc}{/if}</span>
            {/if}
        </div>

        <div class="product-description" itemprop="description">
            {$product.description_short|strip_tags:'UTF-8'|truncate:360:'...'}
        </div>
    </div>
</a>
