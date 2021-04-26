{if !empty($products)}
    <ul {if !empty($id)}id="{$id}"{/if} class="product_list grid list-grid row{if !empty($class)} {$class}{/if}">
        {* IMPORTANT! There must be no spaces betweem </li><li> tags! *}
        {foreach from=$products item=product}<li class="product-list-item grid-item ajax_block_product {$product_block_size_class}">
            {include file='./product-list-item.tpl' product=$product}
        </li>{/foreach}
        {* IMPORTANT! There must be no spaces betweem </li><li> tags! *}
    </ul>
{/if}