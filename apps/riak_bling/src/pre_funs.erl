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

-module(pre_funs).

-export([value_required/1]).

value_required(Object) ->
    case riak_object:get_value(Object) of
        []          -> {fail, "Empty list."};
        undefined   -> {fail, "Undefined value."};
        _           -> Object
    end.
