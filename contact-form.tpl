{assign var=urlSendTo value=$_GET['sendTo']}



<div id="contact-form-page">
{capture name=path}{l s='Contact'}{/capture}


<h1 class="page-heading">
    {if isset($customerThread) && $customerThread}
        {l s='Your Reply'}
    {else}
        {l s='Contact Us'}
    {/if}
</h1>

{if isset($confirmation)}
  <div class="alert alert-success">{l s='Your message has been successfully sent to our team.'}</div>
  <!--<nav>
    <ul class="pager">
      <li class="previous">
        <a href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" class="textlink-nostyle">
          {if $isRtl}&rarr;{else}&larr;{/if} {l s='Home'}
        </a>
      </li>
    </ul>
  </nav>-->
{elseif isset($alreadySent)}
  <div class="alert alert-warning">{l s='Your message has already been sent.'}</div>
  <!--<nav>
    <ul class="pager">
      <li class="previous">
        <a href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" class="textlink-nostyle">
          {if $isRtl}&rarr;{else}&larr;{/if} {l s='Home'}
        </a>
      </li>
    </ul>
  </nav>-->
{else}
  {include file="$tpl_dir./errors.tpl"}

  <form action="{$request_uri}" method="post" class="contact-form-box" enctype="multipart/form-data">
    <fieldset>
      <h3 class="page-subheading">{l s='Send a Message'}</h3>
      <div class="clearfix">

        <div class="template-40percent left-side">
          <div class="form-group selector1">
            <label for="id_contact">{l s='Send To'}</label>
            {if isset($customerThread.id_contact) && $customerThread.id_contact && $contacts|count}
              {assign var=flag value=true}
              {foreach from=$contacts item=contact}
                {if $contact.id_contact == $customerThread.id_contact}
                  <input type="text" class="form-control" id="contact_name" name="contact_name" value="{$contact.name|escape:'html':'UTF-8'}" readonly="readonly">
                  <input type="hidden" name="id_contact" value="{$contact.id_contact|intval}">
                  {$flag=false}
                {/if}
              {/foreach}
              {if $flag && isset($contacts[0].id_contact)}
                <input type="text" class="form-control" id="contact_name" name="contact_name" value="{$contacts[0].name|escape:'html':'UTF-8'}" readonly="readonly">
                <input type="hidden" name="id_contact" value="{$contacts[0].id_contact|intval}">
              {/if}

            {else}
              <select id="id_contact" class="form-control" name="id_contact">
                {foreach from=$contacts item=contact}
                  <option value="{$contact.id_contact|intval}"{if isset($smarty.request.id_contact) && $smarty.request.id_contact == $contact.id_contact  || (isset($urlSendTo) && $urlSendTo== $contact.id_contact)} selected="selected"{/if}>{$contact.name|escape:'html':'UTF-8'}</option>
                {/foreach}
              </select>
              <p id="desc_contact0" class="desc_contact{if isset($smarty.request.id_contact)} unvisible{/if}">&nbsp;</p>
              {foreach from=$contacts item=contact}
                <p id="desc_contact{$contact.id_contact|intval}" class="desc_contact contact-title{if !isset($smarty.request.id_contact) || $smarty.request.id_contact|intval != $contact.id_contact|intval} unvisible{/if}">
                  <i class="icon icon-comment-alt"></i> {$contact.description|escape:'html':'UTF-8'}
                </p>
              {/foreach}
            {/if}
          </div>
          <div class="form-group">
            <label for="email">{l s='Your Email'}</label>
            {if isset($customerThread.email)}
              <input class="form-control" type="email" id="email" name="from" value="{$customerThread.email|escape:'html':'UTF-8'}" readonly="readonly">
            {else}
              <input class="form-control validate" type="email" id="email" name="from" data-validate="isEmail" value="{$email|escape:'html':'UTF-8'}" required>
            {/if}
          </div>
          {if !$PS_CATALOG_MODE}
            {if (!isset($customerThread.id_order) || $customerThread.id_order > 0)}
              <div class="form-group selector1">
                <label>{l s='Order Reference'}</label>
                {if !isset($customerThread.id_order) && isset($is_logged) && $is_logged}
                  <select name="id_order" class="form-control">
                    <option value="0">{l s='-- Choose --'}</option>
                    {foreach from=$orderList item=order}
                      <option value="{$order.value|intval}"{if $order.selected|intval} selected="selected"{/if}>{$order.label|escape:'html':'UTF-8'}</option>
                    {/foreach}
                  </select>
                {elseif !isset($customerThread.id_order) && empty($is_logged)}
                  <input class="form-control" type="text" name="id_order" id="id_order" value="{if isset($customerThread.id_order) && $customerThread.id_order|intval > 0}{$customerThread.id_order|intval}{else}{if isset($smarty.post.id_order) && !empty($smarty.post.id_order)}{$smarty.post.id_order|escape:'html':'UTF-8'}{/if}{/if}">
                {elseif $customerThread.id_order|intval > 0}
                  <input class="form-control" type="text" name="id_order" id="id_order" value="{if isset($customerThread.reference) && $customerThread.reference}{$customerThread.reference|escape:'html':'UTF-8'}{else}{$customerThread.id_order|intval}{/if}" readonly="readonly">
                {/if}
              </div>
            {/if}
            {if isset($is_logged) && $is_logged}
              <div class="form-group selector1">
                {if !isset($customerThread.id_product)}
                    <label class="unvisible">{l s='Product'}</label>
                  {foreach from=$orderedProductList key=id_order item=products name=products}
                    <select name="id_product" id="{$id_order}_order_products" class="unvisible product_select form-control"{if !$smarty.foreach.products.first} style="display:none;"{/if}{if !$smarty.foreach.products.first} disabled="disabled"{/if}>
                      <option value="0">{l s='-- Choose --'}</option>
                      {foreach from=$products item=product}
                        <option value="{$product.value|intval}">{$product.label|escape:'html':'UTF-8'}</option>
                      {/foreach}
                    </select>
                  {/foreach}
                {elseif $customerThread.id_product > 0}
                  <input type="hidden" name="id_product" id="id_product" value="{$customerThread.id_product|intval}" readonly="readonly">
                {/if}
              </div>
            {/if}
          {/if}
          {if $fileupload == 1}
            <div class="form-group">
              <label for="fileUpload">{l s='Attach File'}</label>
              <input type="hidden" name="MAX_FILE_SIZE" value="{if isset($max_upload_size) && $max_upload_size}{$max_upload_size|intval}{else}2000000{/if}">
              <input type="file" name="fileUpload" id="fileUpload" class="form-control">
            </div>
          {/if}
        </div>

        <div class="template-60percent right-side">
          <div class="form-group">
            <label for="message">{l s='Message'}</label>
            <textarea class="form-control" id="message" name="message" rows="20" required>{if isset($message)}{$message|escape:'html':'UTF-8'|stripslashes}{/if}</textarea>
          </div>
        </div>
      </div>

      <div class="submit">
        <button type="submit" name="submitMessage" id="submitMessage" class="btn btn-lg btn-success full-width-mobile">
          <span>{l s='Send'} <i class="icon icon-chevron-right"></i></span>
        </button>
      </div>
    </fieldset>
  </form>
{/if}
{addJsDefL name='contact_fileDefaultHtml'}{l s='No file selected' js=1}{/addJsDefL}
{addJsDefL name='contact_fileButtonHtml'}{l s='Choose File' js=1}{/addJsDefL}

</div>