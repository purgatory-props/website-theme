            </main>
        </div>

{if !isset($content_only) || !$content_only}
        <footer>
            <div class="footer-wrapper wrapper center clearfix">
                {if isset($HOOK_FOOTER)}
                    {$HOOK_FOOTER}
                {/if}

                <div class="copyright small" role="contentinfo" >
                    Copyright © {date("Y")|intval}
                </div>
            </div>
        </footer>
{/if}

        {include file="$tpl_dir./global.tpl"}
    </body>
</html>