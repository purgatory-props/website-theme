<ul class="list-grid row">
    {foreach from=$subcategories item=subcategory}
        <li class="subcategory-item grid-item">
            <a class="grid-item-wrapper" href="{$link->getCategoryLink($subcategory.id_category, $subcategory.link_rewrite)|escape:'html':'UTF-8'}" title="{$subcategory.name|escape:'html':'UTF-8'}">
                <div class="subcategory-picture">
                    <img class="img-responsive center-block subcategory-img"
                                src="{Link::getGenericImageLink(
                                                    'categories',
                                                    $subcategory.id_image,
                                                    'large',
                                                    (ImageManager::retinaSupport()) ? '2x' : ''
                                                )|escape:'htmlall':'UTF-8'}"

                                alt="{$subcategory.name|escape:'html':'UTF-8'}"
                                title="{$subcategory.name|escape:'html':'UTF-8'}"
                                width="{getWidthSize|intval type='large'}"
                                height="{getHeightSize|intval type='large'}"
                            >
                </div>

                <div class="subcategory-title">
                    <h3>{$subcategory.name}</h3>
                </div>
            </a>
        </li>
    {/foreach}
</ul>