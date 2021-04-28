</main>

<div class="tm-home clearfix col-xs-12">
    <div class="wrapper slightly-smaller home-featured center">
        {if isset($products) && $products}
            <div class="tm-hp text-center">
                <h2 class="section-title">{l s='featured' mod='homefeatured'} {l s='products' mod='homefeatured'}</h2>
            </div>
            {include file="$tpl_dir./product-list.tpl" class='homefeatured' id='homefeatured'}
        {else}
            <ul id="homefeatured" class="homefeatured">
                <li class="alert alert-info">{l s='No featured products at this time.' mod='homefeatured'}</li>
            </ul>
        {/if}
    </div>
</div>

<main class="wrapper slightly-smaller main-container">