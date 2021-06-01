{* Do Not Show If Coming Soon, A Service, Or No Reviews *}
{if (!isset($product->coming_soon) || !$product->coming_soon) && (!isset($product->hide_comments) || !$product->hide_comments) && (!isset($product->is_service) || !$product->is_service)}

    {assign var=tabID value="tab-qna"}
    <input name="product-tabs" type="radio" id="{$tabID}" class="tab-switch" autocomplete="off"/>
    <label for="{$tabID}" class="tab-label noselect">{l s='Questions'}</label>

    <div class="product-tab qna-tab">
        {* Ask A Question Form *}
        <form action="" method="POST" id="qna_ask" class="std hidden">
            <div class="field clearfix form-group">
                <label for="qna_q">{l s='Question' mod='prestaqna'} <sup class="required">*</sup></label>
                <textarea name="qna_q" id="qna_q" rows="8" class="form-control" autocomplete="off"></textarea>
            </div>

            <div class="field clearfix required form-group">
                <label for="qna_email">{l s='Email' mod='prestaqna'} <sup class="required">*</sup></label>
                <input type="text" name="qna_email" value="" id="qna_email" class="form-control" autocomplete="email">
                <small>{l s='You will be notified when your question is answered' mod='prestaqna'}</small>
            </div>

            <div class="form-group">
                <input type="hidden" name="qna_name" value="{if $is_logged}{$cookie->customer_firstname} {$cookie->customer_lastname}{else}Guest{/if}"/>
                <input type="hidden" name="qna_prod" value="{$smarty.get.id_product}"/>

                <input type="submit" title="{l s='Ask Question' mod='prestaqna'}" class="btn btn-default" value="{l s='Submit Question' mod='prestaqna'}" style="margin-left: 0px">
                <a title="{l s='Cancel'}" class="btn btn-danger" onclick="toggleQuestionForm()">{l s='Cancel'}</a>
            </div>
        </form>

        <div id="qna-form-alerts">
        </div>

        <button id="ask-question-btn" class="btn btn-success" onclick="toggleQuestionForm()" style="display: block">
            {l s='Ask a Question'}
        </button>

        {* Product Questions *}
        {if isset($qnas) && $qnas}
            <div id="product-questions-container">
                {foreach from=$qnas item=qna}
                    <div class="product-question">
                        <div class="question-title">
                            <span class="icon icon-angle-up expand-icon"></span>
                            <span class="icon icon-angle-down collapse-icon"></span>
                            <span class="title">{$qna.question|escape:'htmlall'}</span>
                        </div>
                        <div class="question-answer">
                            {$qna.answer}
                        </div>
                    </div>
                {/foreach}
            </div>
        {else}
            {l s='There are no questions for this product.'}
        {/if}
    </div>
{/if}


<script>
    var qna_error = "{l s='Whoops! It seems that your request could not be validated, please retry' mod='prestaqna'}",
        qna_badcontent = "{l s='Bad message content!' mod='prestaqna'}",
        qna_badname = "{l s='Bad name content!!' mod='prestaqna'}",
        qna_bademail = "{l s='Bad E-mail address!' mod='prestaqna'}",
        qna_confirm = "{l s='Thank you for your question, it will be answered as quickly as possible.' mod='prestaqna'}";

</script>