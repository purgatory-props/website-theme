<div class="header-search-bar no-mobile">
    <form method="get" action="{$link->getPageLink('search', true)}" id="searchbox">
        <label for="search_query_top"><!-- image on background --></label>
        <input type="hidden" name="controller" value="search">
        <input type="hidden" name="orderby" value="position">
        <input type="hidden" name="orderway" value="desc">

        <div class="input-group input-group-lg">
        <input class="form-control searchbox" type="search" id="search_query_top" name="search_query" placeholder="{l s='Search' mod='blocksearch'}" value="{$search_query|escape:'htmlall':'UTF-8'|stripslashes}" required aria-label="Search our site">

        <span class="input-group-btn">
            <button class="btn btn-primary searchbtn" type="submit" name="submit_search" title="{l s='Search' mod='blocksearch'}"><i class="icon icon-search"></i></button>
        </span>
        </div>

    </form>
</div>