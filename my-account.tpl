<div class="my-account-wrapper">
    {capture name=path}{l s='My account'}{/capture}

    <h1 class="page-heading">{l s='Your Account'}</h1>

    {if isset($account_created)}
        <div class="alert alert-success">{l s='Your account has been created.'}</div>
    {/if}

    {hook h='displayMyAccountTop'}
    <p>{l s='Welcome to your account. Here you can manage all of your personal information and orders.'}</p>

    <div id="my-account-menu" class="row clearfix">
        <div class="col-sm-6">
            <ul class="nav nav-pills nav-stacked stacked-menu">
                {if $has_customer_an_address}
                    <li><a href="{$link->getPageLink('address', true)|escape:'html':'UTF-8'}" title="{l s='Add my first address'}"><i class="icon icon-building"></i> <span>{l s='Add my first address'}</span></a></li>
                {/if}
                <li><a href="{$link->getPageLink('history', true)|escape:'html':'UTF-8'}" title="{l s='Orders'}"><i class="icon icon-list-ol"></i> <span>{l s='Order History and Details'}</span></a></li>
                {if $returnAllowed}
                    <li><a href="{$link->getPageLink('order-follow', true)|escape:'html':'UTF-8'}" title="{l s='Returns'}"><i class="icon icon-refresh"></i> <span>{l s='Returns'}</span></a></li>
                {/if}

                <li><a href="{$link->getPageLink('addresses', true)|escape:'html':'UTF-8'}" title="{l s='Addresses'}"><i class="icon icon-fw icon-building"></i> <span>{l s='Addresses'}</span></a></li>
                <li><a href="{$link->getPageLink('identity', true)|escape:'html':'UTF-8'}" title="{l s='Information'}"><i class="icon icon-user"></i> <span>{l s='Personal Information'}</span></a></li>
            </ul>
        </div>
        {if $voucherAllowed || isset($HOOK_CUSTOMER_ACCOUNT) && $HOOK_CUSTOMER_ACCOUNT !=''}
            <div class="col-sm-6">
                <ul class="nav nav-pills nav-stacked stacked-menu">
                    <li><a href="{$link->getPageLink('order-slip', true)|escape:'html':'UTF-8'}" title="{l s='Credit Slips'}"><i class="icon icon-file-o"></i> <span>{l s='Credit Slips'}</span></a></li>
                    {if $voucherAllowed}
                        <li><a href="{$link->getPageLink('discount', true)|escape:'html':'UTF-8'}" title="{l s='Vouchers'}"><i class="icon icon-barcode"></i> <span>{l s='Vouchers'}</span></a></li>
                    {/if}
                    {$HOOK_CUSTOMER_ACCOUNT}
                </ul>
            </div>
        {/if}
    </div>

    <div class="center text-center">
        <a href="{$link->getPageLink('index', true, NULL, "mylogout")|escape:'html':'UTF-8'}" rel="nofollow" class="btn btn-danger">
            {l s='Sign Out'}
        </a>
    </div>

    {hook h='displayMyAccountBelow'}
</div>