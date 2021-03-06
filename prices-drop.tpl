{capture name=path}{l s='Price Drop'}{/capture}

<h1 class="page-heading product-listing">{l s='Price Drop'}</h1>
{hook h='displayPricesDropTop'}
{if $products}
  <div class="content_sortPagiBar">
    <div class="form-inline sortPagiBar clearfix">
      {include file="./product-sort.tpl"}
      {include file="./nbr-product-page.tpl"}
    </div>
  </div>

  {include file="./product-list.tpl" products=$products}

  <div class="content_sortPagiBar">
    <div class="bottom-pagination-content form-inline clearfix">
      {include file="./pagination.tpl" no_follow=1 paginationId='bottom'}
    </div>
  </div>
{else}
  <div class="alert alert-warning">{l s='No price drop'}</div>
{/if}
{hook h='displayPricesDropBelow'}