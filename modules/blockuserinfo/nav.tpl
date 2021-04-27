<div id="blockuserinfo">
    {if $is_logged}
        <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" title="{l s='Your Account' mod='blockuserinfo'}" rel="nofollow" class="account-info">
            <i class="fa fa-user"></i>
            <span>{$cookie->customer_firstname} {$cookie->customer_lastname}</span>
        </a>
    {else}
        <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Login or Sign Up' mod='blockuserinfo'}" class="account-info">
            <i class="fa fa-sign-in-alt"></i>
            <span>{l s="Login/Signup" mod='blockuserinfo'}</span>
        </a>
    {/if}
</div>