<div id="search-page">
    {capture name=path}{l s='Search'}{/capture}

    <h1 {if isset($instant_search) && $instant_search}id="instant_search_results"{/if}class="page-heading {if !isset($instant_search) || (isset($instant_search) && !$instant_search)} product-listing{/if}">
        {l s='Search'}&nbsp;
        {if $nbProducts > 0}
            <span class="lighter">
                "{if isset($search_query) && $search_query}{$search_query|escape:'html':'UTF-8'}{elseif $search_tag}{$search_tag|escape:'html':'UTF-8'}{elseif $ref}{$ref|escape:'html':'UTF-8'}{/if}"
            </span>
        {/if}
        {if isset($instant_search) && $instant_search}
            <a href="#" class="js-close-instant-search pull-right textlink-nostyle">
                {l s='Return to Previous Page'}
            </a>
        {else}
            {if isset($search_tag) || isset($search_query)}
                <div class="pull-right">
                    <span class="heading-counter badge">
                        {if $nbProducts == 1}{l s='%d Results Found' sprintf=$nbProducts|intval}{else}{l s='%d Results Found' sprintf=$nbProducts|intval}{/if}
                    </span>
                </div>
            {/if}
        {/if}
    </h1>

    {hook h='displaySearchTop'}

    {include file="$tpl_dir./errors.tpl"}

    {if !$nbProducts}
        {if isset($search_query) && $search_query}
            <div class="alert alert-warning">
                {l s='No results were found for your search'}&nbsp;"{if isset($search_query)}{$search_query|escape:'html':'UTF-8'}{/if}"
            </div>
        {elseif isset($search_tag) && $search_tag}
            <div class="alert alert-warning">
                {l s='No results were found for your search'}&nbsp;"{$search_tag|escape:'html':'UTF-8'}"
            </div>
        {else}
            <div class="alert alert-warning no-mobile">
                {l s='Please Enter a Search Term'}
            </div>
        {/if}
    {/if}

    <form method="get" action="{$link->getPageLink('search', true)}" class="no-desktop" style="text-align: center; margin-top: 20px;">
        <input type="hidden" name="controller" value="search">
        <input type="hidden" name="orderby" value="position">
        <input type="hidden" name="orderway" value="desc">

        <input class="form-control searchbox" type="search" id="search_query_top" name="search_query" placeholder="{l s='Search' mod='blocksearch'}" value="{$search_query|escape:'htmlall':'UTF-8'|stripslashes}" required aria-label="Search our site">
        <button class="btn btn-primary center" type="submit" name="submit_search" title="{l s='Search' mod='blocksearch'}">{l s='Search' mod='blocksearch'} <i class="icon icon-search"></i></button>
    </form>

    {if $nbProducts}
        {if isset($instant_search) && $instant_search}
            <div class="alert alert-info">
                {if $nbProducts == 1}{l s='%d Result Found.' sprintf=$nbProducts|intval}{else}{l s='%d Results Found' sprintf=$nbProducts|intval}{/if}
            </div>
        {/if}
        <div class="content_sortPagiBar">
            <div class="form-inline sortPagiBar clearfix{if isset($instant_search) && $instant_search} instant_search{/if}">
                {include file="$tpl_dir./product-sort.tpl"}
                {if !isset($instant_search) || (isset($instant_search) && !$instant_search)}
                    {include file="./nbr-product-page.tpl"}
                {/if}
            </div>
            <div class="top-pagination-content form-inline clearfix" style="display: none">
                {if !isset($instant_search) || (isset($instant_search) && !$instant_search)}
                    {include file="$tpl_dir./pagination.tpl" no_follow=1}
                {/if}
            </div>
        </div>

        {include file="$tpl_dir./product-list.tpl" products=$search_products}

        <div class="content_sortPagiBar">
            <div class="bottom-pagination-content form-inline clearfix">
                {if !isset($instant_search) || (isset($instant_search) && !$instant_search)}
                    {include file="$tpl_dir./pagination.tpl" paginationId='bottom' no_follow=1}
                {/if}
            </div>
        </div>
    {/if}
    {hook h='displaySearchBelow'}
</div>