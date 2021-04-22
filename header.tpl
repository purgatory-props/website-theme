
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>{$meta_tilte|escape:'html':'UTF-8'}</title>

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
    </head>
    <body {if isset($page_name)}id="{$page_name|escape:'html':'UTF-8'}"{/if}
        class="{if isset($page_name)}{$page_name|escape:'html':'UTF-8'}{/if}{if isset($body_classes) && $body_classes|@count} {implode value=$body_classes separator=' '}{/if}">
