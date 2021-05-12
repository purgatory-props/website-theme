{capture name=path}{l s='Sitemap'}{/capture}

<h1 class="page-heading">{l s='Sitemap'}</h1>


<div id="listpage_content" class="row">
  <div class="col-xs-12 col-sm-6">
    <div class="categTree box">
      <h3 class="page-subheading">{l s='Categories'}</h3>
      {*<div class="tree_top">
        <a href="{$base_dir_ssl}" title="{$categoriesTree.name|escape:'html':'UTF-8'}" class="textlink-nostyle"><i class="icon icon-home"></i></a>
      </div>*}
      <ul>
        {if !empty($categoriesTree.children)}
          {foreach $categoriesTree.children as $child}
            {include file="$tpl_dir./category-tree-branch.tpl" node=$child}
          {/foreach}
        {/if}
      </ul>
    </div>
  </div>

  <div class="col-xs-12 col-sm-6">
    <div class="sitemap_block box">
      <h3 class="page-subheading">{l s='Pages'}</h3>
      <ul>
        <li>
          <a href="{$categoriescmsTree.link|escape:'html':'UTF-8'}" title="{$categoriescmsTree.name|escape:'html':'UTF-8'}" class="textlink-nostyle">
            {$categoriescmsTree.name|escape:'html':'UTF-8'}
          </a>
        </li>

        {if !empty($categoriescmsTree.children)}
          {foreach $categoriescmsTree.children as $child}
            {if !empty($child.children) || !empty($child.cms)}
              {include file="$tpl_dir./category-cms-tree-branch.tpl" node=$child}
            {/if}
          {/foreach}
        {/if}

        {foreach from=$categoriescmsTree.cms item=cms name=cmsTree}
          <li><a href="{$cms.link|escape:'html':'UTF-8'}" title="{$cms.meta_title|escape:'html':'UTF-8'}" class="textlink-nostyle">{$cms.meta_title|escape:'html':'UTF-8'}</a></li>
        {/foreach}

        {hook h='displaySitemapPages'}

        <li><a href="{$link->getPageLink('contact', true)|escape:'html':'UTF-8'}" title="{l s='Contact'}" class="textlink-nostyle">{l s='Contact'}</a></li>
        {if $display_store}
          <li><a href="{$link->getPageLink('stores')|escape:'html':'UTF-8'}" title="{l s='List of our stores'}" class="textlink-nostyle">{l s='Our stores'}</a></li>
        {/if}
      </ul>
    </div>
  </div>
</div>

<div id="sitemap_content" class="row">
  <div class="col-xs-12 col-sm-6">
    <div class="sitemap_block box">
      <h3 class="page-subheading">{l s='Offers'}</h3>
      <ul>
        <li><a href="{$link->getPageLink('new-products')|escape:'html':'UTF-8'}" title="{l s='View a new product'}" class="textlink-nostyle">{l s='New Products'}</a></li>
        {if !$PS_CATALOG_MODE}
          {if $PS_DISPLAY_BEST_SELLERS}
            <li><a href="{$link->getPageLink('best-sales')|escape:'html':'UTF-8'}" title="{l s='View top-selling products'}" class="textlink-nostyle">{l s='Best Sellers'}</a></li>
          {/if}
          <li><a href="{$link->getPageLink('prices-drop')|escape:'html':'UTF-8'}" title="{l s='View products with a price drop'}" class="textlink-nostyle">{l s='Price Drops'}</a></li>
        {/if}
        {if $display_manufacturer_link OR $PS_DISPLAY_SUPPLIERS}
          <li><a href="{$link->getPageLink('manufacturer')|escape:'html':'UTF-8'}" title="{l s='View a list of manufacturers'}" class="textlink-nostyle">{l s='Manufacturers'}</a></li>
        {/if}
        {if $display_supplier_link OR $PS_DISPLAY_SUPPLIERS}
          <li><a href="{$link->getPageLink('supplier')|escape:'html':'UTF-8'}" title="{l s='View a list of suppliers'}" class="textlink-nostyle">{l s='Suppliers'}</a></li>
        {/if}
      </ul>
    </div>
  </div>

  <div class="col-xs-12 col-sm-6">
    <div class="sitemap_block box">
      <h3 class="page-subheading">{l s='Account'}</h3>
      <ul>
        {if $is_logged}
          <li><a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Manage your customer account'}" class="textlink-nostyle">{l s='Your Account'}</a></li>
          <li><a href="{$link->getPageLink('identity', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Manage your personal information'}" class="textlink-nostyle">{l s='Personal Information'}</a></li>
          <li><a href="{$link->getPageLink('addresses', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='View a list of my addresses'}" class="textlink-nostyle">{l s='Addresses'}</a></li>
          {if $voucherAllowed}
            <li><a href="{$link->getPageLink('discount', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='View a list of my discounts'}" class="textlink-nostyle">{l s='Discounts'}</a></li>
          {/if}
          <li><a href="{$link->getPageLink('history', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='View a list of my orders'}" class="textlink-nostyle">{l s='Order History'}</a></li>
        {else}
          <li><a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Authentication'}" class="textlink-nostyle">{l s='Authentication'}</a></li>
          <li><a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Create new account'}" class="textlink-nostyle">{l s='Create New Account'}</a></li>
        {/if}
        {if $is_logged}
          <li><a href="{$link->getPageLink('index')}?mylogout" rel="nofollow" title="{l s='Sign out'}" class="textlink-nostyle">{l s='Sign Out'}</a></li>
        {/if}
      </ul>
    </div>
  </div>
</div>

