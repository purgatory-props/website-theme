{assign var=tabID value="tab-videos"}
<input name="product-tabs" type="radio" id="{$tabID}" class="tab-switch" autocomplete="off"/>
<label for="{$tabID}" class="tab-label noselect">{l s='Videos'}</label>

<div class="product-tab videos-tab">
    {foreach from=$videos item=video}
        <h3>{$video.title}</h3>
        <div class="full-width">
            {$video.embed}
        </div>
    {/foreach}
</div>