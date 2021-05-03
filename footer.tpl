{assign var=todaysDate value=date_create(date("Y/m/d"))}
{assign var=nextHalloween value=date_create(date("Y/10/31", (date("m") > 10) ? strtotime('+1 year') : strtotime('+0 minute')))}
{assign var=isHalloween value=(date("m/d") == "10/31")}

{assign var=dateDiff value=date_diff($todaysDate, $nextHalloween)}
{assign var=daysUntilHalloween value=$dateDiff->format('%a')}

{assign var=spookyEmojiList value=['🎃','👻','🦇','🧛‍♂️','💀','🧟‍♂️','🕷','🕸','⚰️']}
{assign var=spookyEmoji value=$spookyEmojiList[array_rand($spookyEmojiList)]}

{assign var=daysWord value=($daysUntilHalloween > 1) ? "days" : "day"}
{assign var=halloweenCountdown value="$daysUntilHalloween $daysWord until Halloween!"}

{if $isHalloween}
    {assign var=halloweenCountdown value="Happy Halloween!"}
{/if}

{if $daysUntilHalloween == 183}
    {assign var=halloweenCountdown value="Halfway to Halloween!"}
{/if}

            </main>
        </div>

        <footer>
            <div class="footer-wrapper wrapper center clearfix">
                {hook h='displayFooter' mod='tbhtmlblock'}
                {hook h='displayFooter' mod='blocksocial'}

                <div class="halloween-countdown text-center spooky-font">
                    <span {if $isHalloween}style="color: #FF5400"{/if}>{$halloweenCountdown}</span>
                     <span style="font-size: 25px">{$spookyEmoji}</span>
                </div>

                <div class="copyright small" role="contentinfo" >
                    Copyright © {date("Y")|intval}
                </div>
            </div>
        </footer>

        {include file="$tpl_dir./global.tpl"}
    </body>
</html>