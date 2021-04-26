 {assign var="showSubcategories" value=false}

 {if !empty($subcategories)}
    {if empty($products) || count($subcategories) > 1}
        {assign var="showSubcategories" value=true}
    {/if}
{/if}

{include file="$tpl_dir./errors.tpl"}
{if !empty($category) && $category->id}
    {if !$category->active}
        <div class="alert alert-warning">{l s='This category is currently unavailable.'}</div>
    {else}
        <div class="category-container">
            <section class="category-info">
                <h1 class="category-title spooky-font no-margin page-heading{if (isset($subcategories) && !$products) || (isset($subcategories) && $products) || !isset($subcategories) && $products} product-listing{/if}">
                    {$category->name|escape:'html':'UTF-8'}
                    {if isset($categoryNameComplement)}
                        &nbsp;{$categoryNameComplement|escape:'html':'UTF-8'}
                    {/if}
                </h1>

                {if !empty($category->description)}
                    <div id="category-description" class="rte">{$category->description}</div>
                {/if}
            </section>
        </div>
    {if $showSubcategories || !empty($products)}
    </main>
    {/if}

    {if $showSubcategories}
        <div class="bg-color-light subcategory-container">
            <div class="wrapper slightly-smaller center category-container">
                    <section class="category-subcategories">
                        {include file='./subcategory-list.tpl'}
                    </section>
            </div>
        </div>
    {/if}

    {if !empty($products)}
        <div class="products-container{if !$showSubcategories} bg-color-light{/if}">
            <div class="category-container">
                <section class="category-products">
                    {if $showSubcategories}<h2 class="section-title">{l s='Products'}</h2>{/if}
                    {include file="./product-list.tpl" products=$products}
                </section>
            </div>
        </div>
    {/if}

    {if $showSubcategories || !empty($products)}
        <main class="wrapper slightly-smaller main-container center">
    {/if}
{/if}
{/if}