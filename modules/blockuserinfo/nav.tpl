<div id="blockuserinfo">
    {if $is_logged}
        <li id="blockuserinfo-customer" class="blockuserinfo">
            <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" title="{l s='View my customer account' mod='blockuserinfo'}" rel="nofollow">
            <span>{$cookie->customer_firstname} {$cookie->customer_lastname}</span>
            </a>
        </li>
    {else}
        <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Login or Sign Up' mod='blockuserinfo'}" class="signup">
            <i class="fa fa-sign-in-alt"></i>
            <span>{l s="Login/Signup" mod='blockuserinfo'}</span>
        </a>
    {/if}
</div>