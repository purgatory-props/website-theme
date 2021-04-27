{assign var='left_column_size' value=0}{assign var='right_column_size' value=0}
{if !empty($display_header)}{include file="$tpl_dir./header.tpl" HOOK_HEADER=$HOOK_HEADER}{/if}
{if !empty($template)}{$template}{/if}
{if !empty($display_footer)}{include file="$tpl_dir./footer.tpl"}{/if}
{if !empty($live_edit)}{$live_edit}{/if}
