{* Login *}
<div class="login-col">
    <form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post" id="login_form" class="box">
        <h3 class="page-subheading">{l s='Login'}</h3>
        <div class="form_content clearfix">
        <div class="form-group">
            <label for="email">{l s='Email address'}</label>
            <input class="is_required validate account_input form-control" data-validate="isEmail" type="email" id="email" name="email" value="{if isset($smarty.post.email)}{$smarty.post.email|stripslashes}{/if}" required focus>
        </div>
        <div class="form-group">
            <label for="passwd">{l s='Password'}</label>
            <input class="is_required validate account_input form-control" type="password" data-validate="isPasswd" id="passwd" name="passwd" value="" required>
        </div>

        <div class="lost_password form-group">
            <a class="lostpassword" href="{$link->getPageLink('password')|escape:'html':'UTF-8'}" title="{l s='Recover your forgotten password'}" rel="nofollow">{l s='Forgot your password?'}</a>
        </div>

        <div class="submit">
            <button type="submit" id="SubmitLogin" name="SubmitLogin" class="btn btn-lg btn-success">
                <i class="icon icon-sign-in"></i> {l s='Sign In'}
            </button>
        </div>
        </div>
    </form>
</div>

{* Sign Up *}
<div class="signup-col">
    <form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post" id="create-account_form" class="box">
        <h3 class="page-subheading">{l s='Need an Account?'}</h3>
        <div class="form_content clearfix">
        <div class="alert alert-danger" id="create_account_error" style="display:none"></div>
        <div class="form-group">
            <label for="email_create">{l s='Email address'}</label>
            <input type="email" class="is_required validate account_input form-control" data-validate="isEmail" id="email_create" name="email_create" value="{if isset($smarty.post.email_create)}{$smarty.post.email_create|stripslashes}{/if}" required>
        </div>
        <div class="submit">
            {if isset($back)}<input type="hidden" class="hidden" name="back" value="{$back|escape:'html':'UTF-8'}">{/if}
            <button class="btn btn-lg btn-success" type="submit" id="SubmitCreate" name="SubmitCreate">
            <i class="icon icon-user-plus"></i> {l s='Create an account'}
            </button>
            <input type="hidden" class="hidden" name="SubmitCreate" value="{l s='Create an Account'}">
        </div>
        </div>
    </form>
</div>