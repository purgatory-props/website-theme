<div id="addresses-page">
    {capture name=path}<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='Your Account'}</a><span class="navigation-pipe">{$navigationPipe}</span><span class="navigation_page">{l s='Addresses'}</span>{/capture}

    <h1 class="page-heading">{l s='Your Addresses'}</h1>

    <p>{l s='Please configure your default billing and shipping addresses when placing an order.'}</p>

    {if !empty($multipleAddresses)}
        <div class="addresses clearfix">
            <p><strong>{l s='Your addresses are listed below.'}</strong></p>
            <p class="p-indent">{l s='Be sure to update your personal information if it has changed.'}</p>

            {assign var="adrs_style" value=$addresses_style}

            <div class="bloc_adresses row">
                {foreach from=$multipleAddresses item=address name=myLoop}
                    <div class="address">
                        <ul class="box list-unstyled">
                            <li>
                                <h3 class="page-subheading">{$address.object.alias}</h3>
                            </li>
                            {foreach from=$address.ordered name=adr_loop item=pattern}
                                {assign var=addressKey value=" "|explode:$pattern}
                                <li>
                                    {foreach from=$addressKey item=key name="word_loop"}
                                        <span {if isset($addresses_style[$key])} class="{$addresses_style[$key]}"{/if}>
                                            {$address.formated[$key|replace:',':'']|escape:'html':'UTF-8'}
                                        </span>
                                    {/foreach}
                                </li>
                            {/foreach}
                            <li class="address_update">
                                <a class="btn btn-success" href="{$link->getPageLink('address', true, null, "id_address={$address.object.id|intval}")|escape:'html':'UTF-8'}" title="{l s='Update'}">
                                    <span>{l s='Update'} <i class="icon icon-refresh"></i></span>
                                </a>
                                <a class="btn btn-danger" href="{$link->getPageLink('address', true, null, "id_address={$address.object.id|intval}&delete")|escape:'html':'UTF-8'}" data-id="addresses_confirm" title="{l s='Delete'}">
                                    <span>{l s='Delete'} <i class="icon icon-remove"></i></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                    {if $smarty.foreach.myLoop.index % 2 && !$smarty.foreach.myLoop.last}
                        </div>
                        <div class="bloc_adresses row">
                    {/if}
                {/foreach}
            </div>
        </div>
    {else}
        <div class="alert alert-warning">{l s='No addresses are available.'}</div>
    {/if}

    <div class="clearfix form-group">
        <a href="{$link->getPageLink('address', true)|escape:'html':'UTF-8'}" title="{l s='Add an address'}" class="btn btn-success" style="margin-left: 0">
            <span><i class="icon icon-plus"></i> {l s='Add a new address'}</span>
        </a>
    </div>



    {addJsDefL name=addressesConfirm}{l s='Are you sure?' js=1}{/addJsDefL}
</div>