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
            <h1 itemprop="name" class="spooky-font">{$product->name|escape:'html':'UTF-8'}</h1>
            <p class="sku" {if empty($product->reference) || !$product->reference} style="display: none;"{/if}>
                <meta itemprop="sku"{if !empty($product->reference) && $product->reference} content="{$product->reference}"{/if}>
                <span>{if !isset($groups)}{$product->reference|escape:'html':'UTF-8'}{/if}</span>
            </p>

            {if $product->description_short}
                <div id="short_description_block">
                    <div id="short_description_content" class="rte" itemprop="description">{$product->description_short}</div>
                </div>
            {/if}

            <div id="oosHook"{if $product->quantity > 0} style="display: none;"{/if}>
                {$HOOK_PRODUCT_OOS}
            </div>
        </div>
    </div>


    <div class="clearfix"></div>
</div>