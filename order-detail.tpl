{if $carrier->id}
    {if $carrier->name == "0"}
        {assign var=shippedWith value=$shop_name}
    {else}
        {assign var=shippedWith value=$carrier->name}
    {/if}
{/if}


<div class="order-detail-container" style="padding-top: 0">
    {if !$is_guest}
        {capture name=path}
            <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='Your Account'}</a>
            <span class="navigation-pipe">{$navigationPipe}</span>
            <a href="{$link->getPageLink('history', true)|escape:'html':'UTF-8'}">{l s='Order History'}</a>
            <span class="navigation_page">{l s='Order'} {if isset($order)}{$order->getUniqReference()}{else}{l s='Details'}{/if}</span>
        {/capture}
    {/if}

    {include file="$tpl_dir./errors.tpl"}

    {if isset($order)}
        {* Order Summary and Reorder *}
        <div id="order-info-summary" class="clearfix">
            {if isset($reorderingAllowed) && $reorderingAllowed}
                <form id="submitReorder" action="{if isset($opc) && $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}" method="post" class="submit">
                    <input type="hidden" value="{$order->id}" name="id_order">
                    <input type="hidden" value="" name="submitReorder">

                    <a href="#" onclick="$(this).closest('form').submit(); return false;" class="btn btn-lg btn-success pull-right hide-print"><span>{l s='Reorder'} <i class="icon icon-refresh"></i></span></a>
                </form>
            {/if}

            <div class="order-reference">
                <h1 class="color-accent" style="display: inline-block; vertical-align: middle">{l s='Order %s' sprintf=$order->getUniqReference()}</h1>
                {if count($order_history)}
                    {assign var=currentState value=$order_history[0]}
                    <span style="display: inline-block; vertical-align: middle; padding: 5px;{if isset($currentState.color) && $currentState.color} background-color:{$currentState.color|escape:'html':'UTF-8'}; border-color:{$currentState.color|escape:'html':'UTF-8'};{/if}" class="label{if isset($currentState.color) && Tools::getBrightness($currentState.color) > 128} dark{/if}">{$currentState.ostate_name|escape:'html':'UTF-8'}</span>
                {/if}
            </div>
            <div class="order-date">{l s='Placed on'} <b>{dateFormat date=$order->date_add full=0}</b></div>

            <div class="order-payment">
                <div>{l s='Payment Method'}: <span class="payment-method">{$order->payment|escape:'html':'UTF-8'}</span></div>
                <div class="order-total">{l s='Total Paid'}: <span class="payment-total bold">{displayWtPriceWithCurrency price=$order->total_paid currency=$currency}</span></div>
            </div>

            {if $carrier->id}
                <div class="order-shipping">
                    {l s='Shipped With'}: <span class="shipping-method">
                        {if isset($followup)}
                        <a href="{$followup|escape:'html':'UTF-8'}" target="_blank" title="{l s='Track Your Order Shipment'}" class="textlink-nostyle external-link">
                        {/if}
                            {$shippedWith|escape:'html':'UTF-8'}
                        {if isset($followup)}
                        </a>
                        {/if}
                    </span>
                </div>
            {/if}

            {if $invoice AND $invoiceAllowed}
                <div class="order-invoice hide-print">
                    <i class="icon icon-file-text"></i>
                    <a class="textlink" target="_blank" href="{$link->getPageLink('pdf-invoice', true)}?id_order={$order->id|intval}{if $is_guest}&amp;secure_key={$order->secure_key|escape:'html':'UTF-8'}{/if}">{l s='Download Invoice'}</a>
                </div>
            {/if}

            {if isset($followup)}
                <div class="order-tracking">
                    <a href="{$followup|escape:'html':'UTF-8'}" class="textlink-nostyle bold external-link no-print" target="_blank">
                        {l s='Track Your Order Shipment'}
                    </a>
                    <span class="only-print">{l s='Track Your Order Shipment'}: {$followup|escape:'html':'UTF-8'}</span>
                </div>
            {/if}

        </div>

        {*<div class="info-order box">
            {if $order->recyclable}
                <p><i class="icon icon-2x text-success icon-repeat"></i> {l s='You have given permission to receive your order in recycled packaging.'}</p>
            {/if}
            {if $order->gift}
                <p><i class="icon icon-2x text-success icon-gift"></i> {l s='You have requested gift wrapping for this order.'}</p>
                <p><strong>{l s='Message'}</strong> {$order->gift_message|nl2br}</p>
            {/if}
        </div>*}

        {$HOOK_ORDERDETAILDISPLAYED}

        {* Order Contents *}
        {if isset($order)}
                </div>
            </main>

            <div id="order-contents-container" class="bg-color-light order-detail-container">
                <div class="wrapper slightly-smaller center">
                    <h2 class="order-details-title">{l s='Order Contents'}</h2>

                    {if !$is_guest}<form action="{$link->getPageLink('order-follow', true)|escape:'html':'UTF-8'}" method="post">{/if}

                    {* Order Contents *}
                    <div id="order-detail-content" class="table_block table-responsive">
                        <table class="table table-bordered order-details-table">
                            <thead>
                                <tr>
                                    {if $return_allowed}
                                        <th class="order_cb">
                                            <div class="checkbox">
                                                <label>
                                                    <input type="checkbox">
                                                    <span class="label-text"></span>
                                                </label>
                                            </div>
                                        </th>
                                    {/if}
                                    <th>{l s='Product'}</th>
                                    <th>{l s='Quantity'}</th>
                                    {if $order->hasProductReturned()}
                                        <th>{l s='Returned'}</th>
                                    {/if}
                                    <th>{l s='Price'}</th>
                                    <th>{l s='Subtotal'}</th>
                                </tr>
                            </thead>

                            <tfoot>
                                <tr class="small">
                                    <td class="total-label" colspan="{if $return_allowed}4{else}3{/if}">
                                        <strong>{l s='Item Total'}</strong>
                                    </td>
                                    <td colspan="{if $order->hasProductReturned()}1{else}1{/if}">
                                        <span class="price">{displayWtPriceWithCurrency price=$order->getTotalProductsWithoutTaxes() currency=$currency}</span>
                                    </td>
                                </tr>
                                <tr class="small">
                                    <td class="total-label" colspan="{if $return_allowed}4{else}3{/if}">
                                        <strong>{l s='Shipping'}</strong>
                                    </td>
                                    <td colspan="{if $order->hasProductReturned()}1{else}1{/if}">
                                        <span class="price-shipping">{displayWtPriceWithCurrency price=$order->total_shipping currency=$currency}</span>
                                    </td>
                                </tr>
                                {if $order->total_discounts > 0}
                                    <tr class="small text-success">
                                        <td class="total-label" colspan="{if $return_allowed}4{else}3{/if}">
                                            <strong>{l s='Promo Codes'}</strong>
                                        </td>
                                        <td colspan="{if $order->hasProductReturned()}1{else}1{/if}">
                                            <span class="price-discount">{displayWtPriceWithCurrency price=$order->total_discounts currency=$currency convert=1}</span>
                                        </td>
                                    </tr>
                                {/if}
                                {if $order->total_wrapping > 0}
                                    <tr class="small">
                                        <td class="total-label" colspan="{if $return_allowed}4{else}3{/if}">
                                            <strong>{l s='Gift Wrapping'}</strong>
                                        </td>
                                        <td colspan="{if $order->hasProductReturned()}1{else}1{/if}">
                                            <span class="price-wrapping">{displayWtPriceWithCurrency price=$order->total_wrapping currency=$currency}</span>
                                        </td>
                                    </tr>
                                {/if}
                                {if $priceDisplay && $use_tax}
                                    <tr class="small">
                                        <td class="total-label" colspan="{if $return_allowed}4{else}3{/if}">
                                            <strong>{l s='Tax'}</strong>
                                        </td>
                                        <td colspan="{if $order->hasProductReturned()}1{else}1{/if}">
                                            {assign var=taxPrice value=$order->getTotalProductsWithTaxes() - $order->getTotalProductsWithoutTaxes()}
                                            <span class="price">{displayWtPriceWithCurrency price=$taxPrice currency=$currency}</span>
                                        </td>
                                    </tr>
                                {/if}
                                <tr class="totalprice color-accent">
                                    <td class="total-label" colspan="{if $return_allowed}4{else}3{/if}">
                                        <strong>{l s='Total'}</strong>
                                    </td>
                                    <td colspan="{if $order->hasProductReturned()}1{else}1{/if}">
                                        <span class="price">{displayWtPriceWithCurrency price=$order->total_paid currency=$currency}</span>
                                    </td>
                                </tr>
                            </tfoot>

                            <tbody>
                                {foreach from=$products item=product name=products}
                                    {if !isset($product.deleted)}
                                        {assign var='productId' value=$product.product_id}
                                        {assign var='productAttributeId' value=$product.product_attribute_id}

                                        {if isset($product.customizedDatas)}
                                            {assign var='productQuantity' value=$product.product_quantity-$product.customizationQuantityTotal}
                                        {else}
                                            {assign var='productQuantity' value=$product.product_quantity}
                                        {/if}

                                        {if isset($product.customizedDatas)}
                                            <tr>
                                                {if $return_allowed}
                                                    <td class="order_cb"></td>
                                                {/if}

                                                <td class="bold">
                                                    <label for="cb_{$product.id_order_detail|intval}">
                                                        {$product.product_name|escape:'html':'UTF-8'}
                                                        {if $product.product_reference}
                                                            <span class="small">({$product.product_reference|escape:'html':'UTF-8'})</span>
                                                        {/if}
                                                    </label>
                                                </td>

                                                <td>
                                                    <input class="order_qte_input form-control text-center"  name="order_qte_input[{$smarty.foreach.products.index}]" type="text" size="2" value="{$product.customizationQuantityTotal|intval}">
                                                    <div class="clearfix return_quantity_buttons">
                                                        <a href="#" class="return_quantity_down btn btn-default button-minus"><i class="icon icon-fw icon-minus"></i></a>
                                                        <a href="#" class="return_quantity_up btn btn-default button-plus"><i class="icon icon-fw icon-plus"></i></a>
                                                    </div>
                                                    <label for="cb_{$product.id_order_detail|intval}">
                                                        <span class="order_qte_span editable">{$product.customizationQuantityTotal|intval}</span>
                                                    </label>
                                                </td>
                                                {if $order->hasProductReturned()}
                                                    <td>
                                                        {$product['qty_returned']}
                                                    </td>
                                                {/if}
                                                <td>
                                                    <label class="price" for="cb_{$product.id_order_detail|intval}">
                                                        {if $group_use_tax}
                                                            {convertPriceWithCurrency price=$product.unit_price_tax_incl currency=$currency}
                                                        {else}
                                                            {convertPriceWithCurrency price=$product.unit_price_tax_excl currency=$currency}
                                                        {/if}
                                                    </label>
                                                </td>
                                                <td>
                                                    <label class="price" for="cb_{$product.id_order_detail|intval}">
                                                        {if isset($customizedDatas.$productId.$productAttributeId)}
                                                            {if $group_use_tax}
                                                                {convertPriceWithCurrency price=$product.total_customization_wt currency=$currency}
                                                            {else}
                                                                {convertPriceWithCurrency price=$product.total_customization currency=$currency}
                                                            {/if}
                                                        {else}
                                                            {if $group_use_tax}
                                                                {convertPriceWithCurrency price=$product.total_price_tax_incl currency=$currency}
                                                            {else}
                                                                {convertPriceWithCurrency price=$product.total_price_tax_excl currency=$currency}
                                                            {/if}
                                                        {/if}
                                                    </label>
                                                </td>
                                            </tr>
                                            {foreach $product.customizedDatas  as $customizationPerAddress}
                                                {foreach $customizationPerAddress as $customizationId => $customization}
                                                    <tr>
                                                        {if $return_allowed}
                                                            <td class="order_cb">
                                                                <input type="checkbox" id="cb_{$product.id_order_detail|intval}" name="customization_ids[{$product.id_order_detail|intval}][]" value="{$customizationId|intval}">
                                                            </td>
                                                        {/if}
                                                        <td colspan="2">
                                                            {foreach from=$customization.datas key='type' item='datas'}
                                                                {if $type == $CUSTOMIZE_FILE}
                                                                    <ul class="customizationUploaded">
                                                                        {foreach from=$datas item='data'}
                                                                            <li><img src="{$pic_dir}{$data.value}_small" alt="" class="customizationUploaded"></li>
                                                                        {/foreach}
                                                                    </ul>
                                                                {elseif $type == $CUSTOMIZE_TEXTFIELD}
                                                                    <ul class="typedText">{counter start=0 print=false}
                                                                        {foreach from=$datas item='data'}
                                                                            {assign var='customizationFieldName' value="Text #"|cat:$data.id_customization_field}
                                                                            <li>{$data.name|default:$customizationFieldName} : {$data.value}</li>
                                                                        {/foreach}
                                                                    </ul>
                                                                {/if}
                                                            {/foreach}
                                                        </td>
                                                        <td>
                                                            <input class="order_qte_input form-control text-center" name="customization_qty_input[{$customizationId|intval}]" type="text" size="2" value="{$customization.quantity|intval}">
                                                            <div class="clearfix return_quantity_buttons">
                                                                <a href="#" class="return_quantity_down btn btn-default button-minus"><i class="icon icon-fw icon-minus"></i></a>
                                                                <a href="#" class="return_quantity_up btn btn-default button-plus"><i class="icon icon-fw icon-plus"></i></a>
                                                            </div>
                                                            <label for="cb_{$product.id_order_detail|intval}">
                                                                <span class="order_qte_span editable">{$customization.quantity|intval}</span>
                                                            </label>
                                                        </td>
                                                        <td colspan="2"></td>
                                                    </tr>
                                                {/foreach}
                                            {/foreach}
                                        {/if}

                                        {if $product.product_quantity > $product.customizationQuantityTotal}
                                            <tr>
                                                {if $return_allowed}
                                                    <td class="order_cb">
                                                        <div class="checkbox">
                                                            <label for="cb_{$product.id_order_detail|intval}">
                                                                <input type="checkbox" id="cb_{$product.id_order_detail|intval}" name="ids_order_detail[{$product.id_order_detail|intval}]" value="{$product.id_order_detail|intval}">
                                                                <span class="label-text"></span>
                                                            </label>
                                                        </div>
                                                    </td>
                                                {/if}

                                                <td class="bold">
                                                    <label for="cb_{$product.id_order_detail|intval}">
                                                        {if $product.download_hash && $logable && $product.display_filename != '' && $product.product_quantity_refunded == 0 && $product.product_quantity_return == 0}
                                                            {assign var=urlExtra value=""}

                                                            {if isset($is_guest) && $is_guest}
                                                                {assign var=urlExtra value="&id_order="+strval($order->id)+"&secure_key="+strval($order->secure_key)}
                                                            {/if}

                                                            <a href="{$link->getPageLink('get-file', true, NULL, "key={$product.filename|escape:'html':'UTF-8'}-{$product.download_hash|escape:'html':'UTF-8'}{$urlExtra}")|escape:'html':'UTF-8'}" title="{l s='Download this Product'}" class="textlink-nostyle">
                                                                <i class="fa fa-download"></i>
                                                                {$product.product_name|escape:'html':'UTF-8'}
                                                            </a>
                                                        {else}
                                                            {$product.product_name|escape:'html':'UTF-8'}
                                                            {if $product.product_reference}
                                                                <span class="small">({$product.product_reference|escape:'html':'UTF-8'})</span>
                                                            {/if}
                                                        {/if}
                                                    </label>
                                                </td>
                                                <td class="return_quantity">
                                                    {if $return_allowed}
                                                        <input class="order_qte_input form-control text-center" name="order_qte_input[{$product.id_order_detail|intval}]" type="text" size="2" value="{$productQuantity|intval}">
                                                        <div class="clearfix return_quantity_buttons pull-left">
                                                            <a href="#" class="return_quantity_down btn btn-default button-minus"><i class="icon icon-fw icon-minus"></i></a>
                                                            <a href="#" class="return_quantity_up btn btn-default button-plus"><i class="icon icon-fw icon-plus"></i></a>
                                                        </div>
                                                    {/if}
                                                    <label for="cb_{$product.id_order_detail|intval}">
                                                        <span class="order_qte_span editable">{$productQuantity|intval}</span>
                                                    </label>
                                                </td>
                                                {if $order->hasProductReturned()}
                                                    <td>
                                                        {$product['qty_returned']}
                                                    </td>
                                                {/if}
                                                <td class="price">
                                                    <label for="cb_{$product.id_order_detail|intval}">
                                                        {if $group_use_tax}
                                                            {convertPriceWithCurrency price=$product.unit_price_tax_incl currency=$currency}
                                                        {else}
                                                            {convertPriceWithCurrency price=$product.unit_price_tax_excl currency=$currency}
                                                        {/if}
                                                    </label>
                                                </td>
                                                <td class="price">
                                                    <label for="cb_{$product.id_order_detail|intval}">
                                                        {if $group_use_tax}
                                                            {convertPriceWithCurrency price=$product.total_price_tax_incl currency=$currency}
                                                        {else}
                                                            {convertPriceWithCurrency price=$product.total_price_tax_excl currency=$currency}
                                                        {/if}
                                                    </label>
                                                </td>
                                            </tr>
                                        {/if}
                                    {/if}
                                {/foreach}

                                {foreach from=$discounts item=discount}
                                    <tr class="text-success">
                                        <td>{$discount.name|escape:'html':'UTF-8'}</td>
                                        <td><span class="order_qte_span editable">1</span></td>
                                        <td>{if $discount.value != 0.00}-{/if}{convertPriceWithCurrency price=$discount.value currency=$currency}</td>
                                        <td>{if $discount.value != 0.00}-{/if}{convertPriceWithCurrency price=$discount.value currency=$currency}</td>
                                        {if $return_allowed}
                                            <td>&nbsp;</td>
                                        {/if}
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>

                    {* Return *}
                    {if $return_allowed}
                        <div id="returnOrderMessage">
                        <h3 class="page-heading">{l s='Merchandise return'}</h3>
                        <p>{l s='If you wish to return one or more products, please mark the corresponding boxes and provide an explanation for the return. When complete, click the button below.'}</p>
                        <div class="form-group">
                            <textarea class="form-control" cols="67" rows="3" name="returnText"></textarea>
                        </div>
                        <div class="form-group">
                            <button type="submit" name="submitReturnMerchandise" class="btn btn-success"><span>{l s='Return'} <i class="icon icon-chevron-right"></i></span></button>
                            <input type="hidden" class="hidden" value="{$order->id|intval}" name="id_order">
                        </div>
                        </div>
                    {/if}

                    {if !$is_guest}</form>{/if}
                </div>
            </div>

            <main class="wrapper slightly-smaller main-container">
                <div class="order-detail-container">
        {/if}


        {* Shipping/Billing Address *}
        <div id="order-address-summary" class="adresses_bloc clearfix">
            <h2 class="order-details-title">{l s='Shipping'}</h2>

            <div class="shipping-address bg-color-dark"{if $order->isVirtual()} style="display:none;"{/if}>
                <ul class="address">
                    <li>
                        <h3 class="page-subheading">{l s='Shipping Address'}</h3>
                    </li>
                    {foreach from=$dlv_adr_fields name=dlv_loop item=field_item}
                        {if $field_item eq "company" && isset($address_delivery->company)}
                            <li class="address_company">{$address_delivery->company|escape:'html':'UTF-8'}</li>
                        {elseif $field_item eq "address2" && $address_delivery->address2}
                            <li class="address_address2">{$address_delivery->address2|escape:'html':'UTF-8'}</li>
                        {elseif $field_item eq "phone_mobile" && $address_delivery->phone_mobile}
                            <li class="address_phone_mobile">{$address_delivery->phone_mobile|escape:'html':'UTF-8'}</li>
                        {else}
                            {assign var=address_words value=" "|explode:$field_item}
                            <li>
                                {foreach from=$address_words item=word_item name="word_loop"}
                                    {if !$smarty.foreach.word_loop.first} {/if}<span class="address_{$word_item|replace:',':''}">{$deliveryAddressFormatedValues[$word_item|replace:',':'']|escape:'html':'UTF-8'}</span>
                                {/foreach}
                            </li>
                        {/if}
                    {/foreach}
                </ul>
            </div>
            <div class="billing-address bg-color-dark" {if $order->isVirtual()}style="float: left"{/if}>
                <ul class="address">
                    <li>
                        <h3 class="page-subheading">{l s='Billing Address'}</h3>
                    </li>
                    {foreach from=$inv_adr_fields name=inv_loop item=field_item}
                        {if $field_item eq "company" && isset($address_invoice->company)}
                            <li class="address_company">{$address_invoice->company|escape:'html':'UTF-8'}</li>
                        {elseif $field_item eq "address2" && $address_invoice->address2}
                            <li class="address_address2">{$address_invoice->address2|escape:'html':'UTF-8'}</li>
                        {elseif $field_item eq "phone_mobile" && $address_invoice->phone_mobile}
                            <li class="address_phone_mobile">{$address_invoice->phone_mobile|escape:'html':'UTF-8'}</li>
                        {else}
                            {assign var=address_words value=" "|explode:$field_item}
                            <li>
                                {foreach from=$address_words item=word_item name="word_loop"}
                                    {if !$smarty.foreach.word_loop.first} {/if}<span class="address_{$word_item|replace:',':''}">{$invoiceAddressFormatedValues[$word_item|replace:',':'']|escape:'html':'UTF-8'}</span>
                                {/foreach}
                            </li>
                        {/if}
                    {/foreach}
                </ul>
            </div>
        </div>

        {* Shipping *}
        {assign var='carriers' value=$order->getShipping()}
        {if $carriers|count > 0 && isset($carriers[0].carrier_name) && $carriers[0].carrier_name}
            <div class="table-responsive">
                <table class="table table-bordered footab order-details-table">
                    <thead>
                    <tr>
                    <th>{l s='Date'}</th>
                    <th data-sort-ignore="true">{l s='Carrier'}</th>
                    <th data-hide="phone">{l s='Weight'}</th>
                    <th data-hide="phone">{l s='Shipping Cost'}</th>
                    <th data-hide="phone" data-sort-ignore="true">{l s='Tracking Number'}</th>
                    </tr>
                    </thead>
                    <tbody>
                    {foreach from=$carriers item=line}
                    <tr>
                        <td data-value="{$line.date_add|regex_replace:"/[\-\:\ ]/":""}">{dateFormat date=$line.date_add full=0}</td>
                        <td>{$line.carrier_name}</td>
                        <td data-value="{if $line.weight > 0}{$line.weight|string_format:"%.3f"}{else}0{/if}">{if $line.weight > 0}{$line.weight|string_format:"%.3f"} {Configuration::get('PS_WEIGHT_UNIT')}{else}-{/if}</td>
                        <td data-value="{if $order->getTaxCalculationMethod() == $smarty.const.PS_TAX_INC}{$line.shipping_cost_tax_incl}{else}{$line.shipping_cost_tax_excl}{/if}">{if $order->getTaxCalculationMethod() == $smarty.const.PS_TAX_INC}{displayPrice price=$line.shipping_cost_tax_incl currency=$currency->id}{else}{displayPrice price=$line.shipping_cost_tax_excl currency=$currency->id}{/if}</td>
                        <td>
                        <span class="shipping_number_show">{if $line.tracking_number}{if $line.url && $line.tracking_number}<a href="{$line.url|replace:'@':$line.tracking_number}" class="textlink-nostyle external-link" target="_blank">{$line.tracking_number}</a>{else}{$line.tracking_number}{/if}{else}-{/if}</span>
                        </td>
                    </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        {/if}

        {* Order Status History *}
        {if count($order_history)}
                </div>
            </main>

            <div id="order-status-history-container" class="bg-color-light order-detail-container">
                <div class="wrapper slightly-smaller center">
                    <div id="order-history-summary">
                        <h2 class="order-details-title">{l s='Order Status'}</h2>
                        <div class="table_block table-responsive">
                            <table class="detail_step_by_step table table-bordered">
                                <thead>
                                    <tr>
                                        <th>{l s='Date'}</th>
                                        <th>{l s='Status'}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach from=$order_history item=state name="orderStates"}
                                        <tr>
                                            <td class="step-by-step-date">{dateFormat date=$state.date_add full=0}</td>
                                            <td><span {if isset($state.color) && $state.color}style="background-color:{$state.color|escape:'html':'UTF-8'}; border-color:{$state.color|escape:'html':'UTF-8'};"{/if} class="label{if isset($state.color) && Tools::getBrightness($state.color) > 128} dark{/if}">{$state.ostate_name|escape:'html':'UTF-8'}</span></td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <main class="wrapper slightly-smaller main-container">
                <div class="order-detail-container">
        {/if}

        {* Messages *}
        {if !$is_guest}
            {if count($messages)}
                <h2 id="messages" class="page-heading order-details-title no-print">{l s='Messages'}</h2>
                <div class="table_block table-responsive no-print">
                    <table class="detail_step_by_step table table-bordered order-details-table">
                    <thead>
                    <tr>
                        <th style="width:150px;">{l s='From'}</th>
                        <th>{l s='Message'}</th>
                    </tr>
                    </thead>
                    <tbody class="no-even-rows">
                        {foreach from=$messages item=message name="messageList"}
                            <tr {if (isset($message.elastname) && $message.elastname) || (!$message.cfirstname)}class="other-color"{/if}>
                                <td>
                                    <strong>
                                        {if isset($message.elastname) && $message.elastname}
                                            {$shop_name|escape:'html':'UTF-8'}{*{$message.efirstname|escape:'html':'UTF-8'} {$message.elastname|escape:'html':'UTF-8'}*}
                                        {elseif $message.clastname}
                                            {$message.cfirstname|escape:'html':'UTF-8'} {$message.clastname|escape:'html':'UTF-8'}
                                        {else}
                                            {$shop_name|escape:'html':'UTF-8'}
                                        {/if}
                                    </strong>
                                    <br>
                                    <span class="time small">{dateFormat date=$message.date_add full=1}</span>
                                </td>
                                <td>{$message.message|escape:'html':'UTF-8'|nl2br}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                    </table>
                </div>
            {/if}

            {if isset($errors) && $errors}
                <div class="alert alert-danger">
                    <p>{if $errors|@count > 1}{l s='There are %d errors' sprintf=$errors|@count}{else}{l s='There is %d error' sprintf=$errors|@count}{/if}</p>
                    <ol>
                    {foreach from=$errors key=k item=error}
                        <li>{$error}</li>
                    {/foreach}
                    </ol>
                </div>
            {/if}

            {if isset($message_confirmation) && $message_confirmation}
                <div class="alert alert-success no-print">
                    {l s='Message successfully sent'}
                </div>
            {/if}

            <form action="{$link->getPageLink('order-detail', true)|escape:'html':'UTF-8'}" method="post" class="std no-print" id="sendOrderMessage">
                <h3 class="page-heading">{l s='Add a Message'}</h3>
                <p>{l s='If you would like to add a comment about your order, please write it in the field below.'}</p>
                <div class="form-group">
                    <label for="id_product" style="display: block">{l s='Product'}</label>
                    <select name="id_product" class="form-control">
                    <option value="0">{l s='-- Choose --'}</option>
                    {foreach from=$products item=product name=products}
                        <option value="{$product.product_id}">{$product.product_name}</option>
                    {/foreach}
                    </select>
                </div>
                <div class="form-group" style="margin-top: 10px">
                    <textarea class="form-control" cols="67" rows="3" name="msgText" style="width: 100%"></textarea>
                </div>
                <div class="submit">
                    <input type="hidden" name="id_order" value="{$order->id|intval}">
                    <input type="submit" class="unvisible" name="submitMessage" value="{l s='Send'}">
                    <button type="submit" name="submitMessage" class="btn btn-lg btn-success full-width-mobile" style="margin-left: 0"><span>{l s='Send'} <i class="icon icon-chevron-right"></i></span></button>
                </div>
            </form>
        {else}
            {if $return_allowed}
                <div class="alert alert-info">{l s='You Can Not Return Items With a Guest Account'}</div>
            {/if}
        {/if}
    {/if}

</div>