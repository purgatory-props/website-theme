<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>{$meta_title|escape:'html':'UTF-8'}</title>

        {if isset($meta_description) AND $meta_description}
            <meta name="description" content="{$meta_description|escape:'html':'UTF-8'}">
        {/if}
        {if isset($meta_keywords) AND $meta_keywords}
            <meta name="keywords" content="{$meta_keywords|escape:'html':'UTF-8'}">
        {/if}

        <meta name="robots" content="{if isset($nobots)}no{/if}index,{if isset($nofollow) && $nofollow}no{/if}follow">
        <meta name="viewport" content="width=device-width, minimum-scale=0.25, maximum-scale=5, initial-scale=1.0">

        <link rel="icon" type="image/vnd.microsoft.icon" href="{$favicon_url}?{$img_update_time}">
        <link rel="shortcut icon" type="image/x-icon" href="{$favicon_url}?{$img_update_time}">

        {if isset($css_files)}
            {foreach from=$css_files key=css_uri item=media}
                {if $css_uri == 'lteIE9'}
                    <!--[if lte IE 9]>
                    {foreach from=$css_files[$css_uri] key=css_uriie9 item=mediaie9}
                    <link rel="stylesheet" href="{$css_uriie9|escape:'html':'UTF-8'}" type="text/css" media="{$mediaie9|escape:'html':'UTF-8'}" >
                    {/foreach}
                    <![endif]-->
                {else}
                    <link rel="stylesheet" href="{$css_uri|escape:'html':'UTF-8'}" type="text/css" media="{$media|escape:'html':'UTF-8'}" >
                {/if}
            {/foreach}
        {/if}

        {if isset($js_defer) && !$js_defer && isset($js_files) && isset($js_def)}
            {$js_def}
            {foreach from=$js_files item=js_uri}
                <script type="text/javascript" src="{$js_uri|escape:'html':'UTF-8'}"></script>
            {/foreach}
        {/if}

        {$HOOK_HEADER}

        <!--[if IE 8]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js" async></script>
        <![endif]-->
        <script src="https://polyfill.io/v2/polyfill.min.js?features=IntersectionObserver" data-keepinline></script>
        <script type="text/javascript" data-keepinline>
            document.createElement('picture');
        </script>

        <script src="{$tpl_uri|escape:'htmlall':'UTF-8'}js/vendor/picturefill.min.js" data-keepinline async></script>
        <script src="{$tpl_uri|escape:'htmlall':'UTF-8'}js/vendor/picturefill-mutation.min.js" data-keepinline async></script>
    </head>
    <body {if isset($page_name)}id="{$page_name|escape:'html':'UTF-8'}"{/if} class="{if isset($page_name)}{$page_name|escape:'html':'UTF-8'}{/if}{if isset($body_classes) && $body_classes|@count} {implode value=$body_classes separator=' '}{/if}">

    {if !isset($content_only) || !$content_only}

    <!-- Banner -->
    {capture name='displayBanner'}{hook h='displayBanner'}{/capture}
    {if $smarty.capture.displayBanner}
        <div id="header-banners">
            {$smarty.capture.displayBanner}
        </div>
    {/if}

    <!-- Header -->
    <header>
        <div class="header-wrapper header-top">
            <div class="shop-logo">
                <a href="{$link->getPageLink('index', true)|escape:'html':'UTF-8'}" title="{$shop_name|escape:'html':'UTF-8'}">
                    <img class="img-responsive center-block" src="{$logo_url}" alt="{$shop_name|escape:'html':'UTF-8'}" title="{$shop_name|escape:'html':'UTF-8'}"{if isset($logo_image_width) && $logo_image_width} width="{$logo_image_width}"{/if}{if isset($logo_image_height) && $logo_image_height} height="{$logo_image_height}"{/if}>
                </a>
            </div>

            {hook h='displayTop' mod='blocksearch'}

            <div class="clearfix"></div>
        </div>

        {hook h='displayNav' mod='blocktopmenu'}

    </header>
{/if}