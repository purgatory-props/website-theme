{capture name=path}{l s='Guest Tracking'}{/capture}

<h1 class="page-heading">{l s='Guest Tracking'}</h1>

{if isset($order_collection)}
    {foreach $order_collection as $order}
        {assign var=order_state value=$order->getCurrentState()}
        {assign var=invoice value=$order->invoice}
        {assign var=order_history value=$order->order_history}
        {assign var=carrier value=$order->carrier}
        {assign var=address_invoice value=$order->address_invoice}
        {assign var=address_delivery value=$order->address_delivery}
        {assign var=inv_adr_fields value=$order->inv_adr_fields}
        {assign var=dlv_adr_fields value=$order->dlv_adr_fields}
        {assign var=invoiceAddressFormatedValues value=$order->invoiceAddressFormatedValues}
        {assign var=deliveryAddressFormatedValues value=$order->deliveryAddressFormatedValues}
        {assign var=currency value=$order->currency}
        {assign var=discounts value=$order->discounts}
        {assign var=invoiceState value=$order->invoiceState}
        {assign var=deliveryState value=$order->deliveryState}
        {assign var=products value=$order->products}
        {assign var=customizedDatas value=$order->customizedDatas}
        {assign var=HOOK_ORDERDETAILDISPLAYED value=$order->hook_orderdetaildisplayed}
        {if isset($order->total_old)}
            {assign var=total_old value=$order->total_old}
        {/if}
        {if isset($order->followup)}
            {assign var=followup value=$order->followup}
        {/if}

        <div id="block-history">
            <div id="block-order-detail" class="std">
                {include file="./order-detail.tpl"}
            </div>
        </div>
    {/foreach}

    <div class="order-detail-container wrapper slightly-smaller center">
        <h2 id="guestToCustomer" class="page-heading">{l s='Create an Account'}</h2>

        {include file="$tpl_dir./errors.tpl"}

        {if isset($transformSuccess)}
            <div class="alert alert-success">{l s='You Have Converted to a Registered Account!'} <a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}">{l s='Log In Now.'}</a></div>
        {else}
            <form method="post" action="{$action|escape:'html':'UTF-8'}#guestToCustomer" class="std">
                <fieldset class="description_box">
                    <p>{l s='To create an account, please set a password.'}</p>
                    <div class="row">
                        <div class="col-xs-12 col-sm-5 col-md-4 col-lg-3">
                            <div class="text form-group">
                                <label for="guest-order-password"><strong>{l s='Password'}</strong></label>
                                <input id="guest-order-password" type="password" name="password" class="form-control">
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="id_order" value="{if isset($order->id)}{$order->id}{else}{if isset($smarty.get.id_order)}{$smarty.get.id_order|escape:'html':'UTF-8'}{else}{if isset($smarty.post.id_order)}{$smarty.post.id_order|escape:'html':'UTF-8'}{/if}{/if}{/if}">
                    <input type="hidden" name="order_reference" value="{if isset($smarty.get.order_reference)}{$smarty.get.order_reference|escape:'html':'UTF-8'}{else}{if isset($smarty.post.order_reference)}{$smarty.post.order_reference|escape:'html':'UTF-8'}{/if}{/if}">
                    <input type="hidden" name="email" value="{if isset($smarty.get.email)}{$smarty.get.email|escape:'html':'UTF-8'}{else}{if isset($smarty.post.email)}{$smarty.post.email|escape:'html':'UTF-8'}{/if}{/if}">

                    <p>
                    <button type="submit" name="submitTransformGuestToCustomer" class="btn btn-lg btn-success">
                        <span>{l s='Create Account'} <i class="icon icon-chevron-right"></i></span>
                    </button>
                    </p>
                </fieldset>
            </form>
        {/if}
    </div>
{else}
  {include file="$tpl_dir./errors.tpl"}
  {if isset($show_login_link) && $show_login_link}
    <p><img src="{$img_dir}icon/userinfo.gif" alt="{l s='Information'}" class="icon"><a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='Log In to Account'}</a><br><br></p>
  {/if}
  <form method="post" action="{$action|escape:'html':'UTF-8'}" class="std" id="guestTracking">
    <fieldset class="description_box">
      <h3 class="page-subheading">{l s='To track your order, please enter the following information:'}</h3>
      <div class="text form-group">
        <label for="guest-order-reference">{l s='Order Reference:'} </label>
        <input id="guest-order-reference" class="form-control" type="text" name="order_reference" value="{if isset($smarty.get.id_order)}{$smarty.get.id_order|escape:'html':'UTF-8'}{else}{if isset($smarty.post.id_order)}{$smarty.post.id_order|escape:'html':'UTF-8'}{/if}{/if}" size="8" required>
        <p class="help-block">{l s='For example: QIIXJXNUI or QIIXJXNUI#1'}</p>
      </div>
      <div class="text form-group">
        <label for="guest-order-email">{l s='Email:'}</label>
        <input id="guest-order-email" class="form-control" type="email" name="email" value="{if isset($smarty.get.email)}{$smarty.get.email|escape:'html':'UTF-8'}{else}{if isset($smarty.post.email)}{$smarty.post.email|escape:'html':'UTF-8'}{/if}{/if}" required>
      </div>
      <p>
        <button type="submit" name="submitGuestTracking" class="btn btn-lg btn-success">
          <span>{l s='Track'} <i class="icon icon-chevron-right"></i></span>
        </button>
      </p>
    </fieldset>
  </form>
{/if}
