%% -------------------------------------------------------------------
%%
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%  http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(hooks).

-export([install_pre/3, install_post/3,
         uninstall_pre/3, uninstall_post/3]).

install_pre(Client, Bucket, Fun) ->
    install_hook(Client, pre, Bucket, pre_funs, Fun).

install_post(Client, Bucket, Fun) ->
    install_hook(Client, post, Bucket, post_funs, Fun).
                  
install_hook(Client, Hook, Bucket, Mod, Fun) ->
    BucketList = Client:get_bucket(Bucket),
    HookList = proplists:get_value(Hook, BucketList),
    Def = {struct, [{<<"mod">>,atom_to_binary(Mod,latin1)}, {<<"fun">>,atom_to_binary(Fun, latin1)}]},
    case lists:member(Def, HookList) of
        true ->
            NewList = HookList;
        false ->
            NewList = HookList ++ [Def]
    end,
    Client:set_bucket(Bucket, [{Hook, NewList}]).

uninstall_pre(Client, Bucket, all) ->
    uninstall_hook(Client, pre, Bucket, all);
uninstall_pre(Client, Bucket, Fun) ->
    uninstall_hook(Client, pre, Bucket, pre_funs, Fun).

uninstall_post(Client, Bucket, all) ->
    uninstall_hook(Client, post, Bucket, all);
uninstall_post(Client, Bucket, Fun) ->
    uninstall_hook(Client, post, Bucket, post_funs, Fun).

uninstall_hook(Client, Hook, Bucket, all) ->
    Client:set_bucket(Bucket, [{Hook, []}]).

uninstall_hook(Client, Hook, Bucket, Mod, Fun) ->
    BucketList = Client:get_bucket(Bucket),
    HookList = proplists:get_value(Hook, BucketList),
    Def = {struct, [{<<"mod">>,atom_to_binary(Mod,latin1)}, {<<"fun">>,atom_to_binary(Fun, latin1)}]},
    NewList = lists:delete(Def, HookList),
    Client:set_bucket(Bucket, [{Hook, NewList}]).
