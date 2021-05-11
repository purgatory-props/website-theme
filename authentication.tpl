{include file="$tpl_dir./errors.tpl"}

{assign var='stateExist' value=false}
{assign var="postCodeExist" value=false}
{assign var="dniExist" value=false}



<div id="authContainer" class="authentication-container clearfix-after">
    {hook h='displayAuthenticationTop'}
    {if isset($back) && preg_match("/^http/", $back)}{assign var='current_step' value='login'}{include file="$tpl_dir./order-steps.tpl"}{/if}

    {if !isset($email_create)}
      {if isset($inOrderProcess) && $inOrderProcess && $PS_GUEST_CHECKOUT_ENABLED}
        {include './authentication-create-guest.tpl'}
      {/if}
      {include './authentication-login.tpl'}

    {else}
        {include './authentication-create.tpl'}
    {/if}
</div>

{strip}
  {if isset($smarty.post.id_state) && $smarty.post.id_state}
    {addJsDef idSelectedState=$smarty.post.id_state|intval}
  {elseif isset($address->id_state) && $address->id_state}
    {addJsDef idSelectedState=$address->id_state|intval}
  {else}
    {addJsDef idSelectedState=false}
  {/if}
  {if isset($smarty.post.id_state_invoice) && isset($smarty.post.id_state_invoice) && $smarty.post.id_state_invoice}
    {addJsDef idSelectedStateInvoice=$smarty.post.id_state_invoice|intval}
  {else}
    {addJsDef idSelectedStateInvoice=false}
  {/if}
  {if isset($smarty.post.id_country) && $smarty.post.id_country}
    {addJsDef idSelectedCountry=$smarty.post.id_country|intval}
  {elseif isset($address->id_country) && $address->id_country}
    {addJsDef idSelectedCountry=$address->id_country|intval}
  {else}
    {addJsDef idSelectedCountry=false}
  {/if}
  {if isset($smarty.post.id_country_invoice) && isset($smarty.post.id_country_invoice) && $smarty.post.id_country_invoice}
    {addJsDef idSelectedCountryInvoice=$smarty.post.id_country_invoice|intval}
  {else}
    {addJsDef idSelectedCountryInvoice=false}
  {/if}
  {if isset($countries)}
    {addJsDef countries=$countries}
  {/if}
  {if isset($vatnumber_ajax_call) && $vatnumber_ajax_call}
    {addJsDef vatnumber_ajax_call=$vatnumber_ajax_call}
  {/if}
  {if isset($email_create) && $email_create}
    {addJsDef email_create=$email_create|boolval}
  {else}
    {addJsDef email_create=false}
  {/if}
{/strip}
{hook h='displayAuthenticationBottom'}