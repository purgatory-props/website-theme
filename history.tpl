{capture name=path}
  <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
    {l s='My Account'}
  </a>
  <span class="navigation-pipe">{$navigationPipe}</span>
  <span class="navigation_page">{l s='Order history'}</span>
{/capture}

<div id="order-history-container" class="clearfix">
     <nav>
        <ul class="pager">
            <li class="previous list-nostyle">
                <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" class="textlink-nostyle" style="margin-left: 0;">
                    {if $isRtl}&rarr;{else}&larr;{/if} {l s='Back to Account'}
                </a>
            </li>
        </ul>
    </nav>

    {include file="$tpl_dir./errors.tpl"}

    <h1 class="page-heading">{l s='Order History'}</h1>
    <p><b>{l s='Here are the orders you\'ve placed since your account was created.'}</b></p>

    {if $slowValidation}
        <div class="alert alert-warning">{l s='If you have just placed an order, it may take a few minutes for it to be validated. Please refresh this page if your order is missing.'}</div>
    {/if}

    <div class="block-center" id="block-history">
    {if $orders && count($orders)}
        <div class="table-responsive">
            <table id="order-list" class="table table-bordered footab">
                <thead>
                    <tr>
                        <th data-sort-ignore="true">{l s='Order Reference'}</th>
                        <th>{l s='Date'}</th>
                        <th data-hide="phone">{l s='Total Price'}</th>
                        <th data-sort-ignore="true" data-hide="phone,tablet">{l s='Payment'}</th>
                        <th>{l s='Status'}</th>
                        <th data-sort-ignore="true" data-hide="phone,tablet">{l s='Invoice'}</th>
                        <th data-sort-ignore="true" data-hide="phone,tablet">&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                {foreach from=$orders item=order name=myLoop}
                    <tr>
                        <td class="history_link bold">
                            <a class="textlink-nostyle" href="{$link->getPageLink('order-detail', true, NULL, "id_order={$order.id_order|intval}")|escape:'html':'UTF-8'}">
                                 {if isset($order.invoice) && $order.invoice && isset($order.virtual) && $order.virtual}
                                    <i class="fa fa-download"></i>
                                {/if}
                                {Order::getUniqReferenceOf($order.id_order)}
                            </a>
                        </td>
                        <td data-value="{$order.date_add|regex_replace:"/[\-\:\ ]/":""}" class="history_date">
                            {dateFormat date=$order.date_add full=0}
                        </td>
                        <td class="history_price" data-value="{$order.total_paid}">
                            <span class="price">
                                {displayPrice price=$order.total_paid currency=$order.id_currency no_utf8=false convert=false}
                            </span>
                        </td>
                        <td class="history_method">
                            {$order.payment|escape:'html':'UTF-8'}
                        </td>
                        <td{if isset($order.order_state)} data-value="{$order.id_order_state}"{/if} class="history_state">
                            {if isset($order.order_state)}
                                <span class="label{if isset($order.order_state_color) && Tools::getBrightness($order.order_state_color) > 128} dark{/if}"{if isset($order.order_state_color) && $order.order_state_color} style="background-color:{$order.order_state_color|escape:'html':'UTF-8'}; border-color:{$order.order_state_color|escape:'html':'UTF-8'};"{/if}>
                                    {$order.order_state|escape:'html':'UTF-8'}
                                </span>
                            {/if}
                        </td>
                        <td class="history_invoice">
                            {if (isset($order.invoice) && $order.invoice && isset($order.invoice_number) && $order.invoice_number) && isset($invoiceAllowed) && $invoiceAllowed == true}
                                <a class="btn btn-default" href="{$link->getPageLink('pdf-invoice', true, NULL, "id_order={$order.id_order}")|escape:'html':'UTF-8'}" title="{l s='Invoice'}" target="_blank">
                                    <i class="icon icon-file-text large"></i> {l s='PDF'}
                                </a>
                            {else}
                                -
                            {/if}
                        </td>
                        <td class="history_detail">
                            <a class="btn btn-default" href="{$link->getPageLink('order-detail', true, NULL, "id_order={$order.id_order|intval}")|escape:'html':'UTF-8'}">
                                <span>
                                    {l s='Details'} <i class="icon icon-chevron-right"></i>
                                </span>
                            </a>
                            {if isset($reorderingAllowed) && $reorderingAllowed}
                                {if isset($opc) && $opc}
                                    <a class="btn btn-default" href="{$link->getPageLink('order-opc', true, NULL, "submitReorder&id_order={$order.id_order|intval}")|escape:'html':'UTF-8'}" title="{l s='Reorder'}">
                                {else}
                                    <a class="btn btn-default" href="{$link->getPageLink('order', true, NULL, "submitReorder&id_order={$order.id_order|intval}")|escape:'html':'UTF-8'}" title="{l s='Reorder'}">
                                {/if}
                                    <i class="icon icon-refresh"></i> {l s='Reorder'}
                                </a>
                            {/if}
                        </td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        </div>
        <div id="block-order-detail" class="unvisible">&nbsp;</div>
    {else}
        <div class="alert alert-warning">{l s='You have not placed any orders.'}</div>
    {/if}
    </div>


</div>

