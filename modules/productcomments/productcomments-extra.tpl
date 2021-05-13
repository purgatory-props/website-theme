
{if (!$content_only && (($nbComments == 0 && $too_early == false && ($logged || $allow_guests)) || ($nbComments != 0)))}
  <div id="product_comments_block_extra">
    {if $nbComments != 0}
      <div class="comments_note">
        <div class="product-stars clearfix">
            {section name="i" start=0 loop=5 step=1}
                {if $averageTotal le $smarty.section.i.index}
                    <div class="star"></div>
                {else}
                    <div class="star star_on"></div>
                {/if}
            {/section}

            <a style="font-size: 1.3em; line-height: 1em; margin-left: 5px;" class="textlink-nostyle" title="{l s='View Reviews'}" onclick="GoToProductTab('tab-reviews'); return false;">({$nbComments})</a>
        </div>
      </div>
    {/if}
  </div>
{/if}
<!--  /Module ProductComments -->
