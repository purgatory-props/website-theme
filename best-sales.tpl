{capture name=path}{l s='Top Sellers'}{/capture}

<h1 class="page-heading product-listing">{l s='Top Sellers'}</h1>

{if $products}
  <div class="content_sortPagiBar">
    <div class="form-inline sortPagiBar clearfix">
      {include file="./product-sort.tpl"}
      {include file="./nbr-product-page.tpl"}
    </div>
  </div>

  {include file="./product-list.tpl" products=$products}

  <div class="content_sortPagiBar center text-center">
    <div class="bottom-pagination-content form-inline clearfix">
      {include file="./pagination.tpl" paginationId='bottom'}
    </div>
  </div>
{else}
  <div class="alert alert-warning">{l s='No top sellers for the moment.'}</div>
{/if}

